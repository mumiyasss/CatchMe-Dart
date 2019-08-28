import 'dart:async';

import 'package:catch_me/ui/writeToNewPerson/NewMessage.dart';
import 'package:flutter/material.dart';
import 'package:catch_me/ui/chatlist/chat_list.dart';
import 'package:catch_me/ui/settings/Settings.dart';
import 'package:flutter/services.dart';
import 'AppBar.dart';
import 'package:catch_me/values/Dimens.dart';

class MainPage extends StatelessWidget {
    static final pageViewStreamController = StreamController<double>.broadcast(
        sync: true);

    final pageView = PageView(
        physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[

            Settings(),
            ChatList(),


        ],
    );

    plugPositionListener() {
        if (!pageView.controller.hasClients) {
            Future.delayed(Duration(milliseconds: 500)).then((_) {
                plugPositionListener();
            });
        } else {
            pageView.controller.position.addListener(_pageViewListener);
        }
    }

    _pageViewListener() {
        pageViewStreamController.add(pageView.controller.position.pixels);
    }

    @override
    Widget build(BuildContext context) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.white,
        ));
        var appBar = MyAppBar(pageViewStreamController);
        plugPositionListener();
        return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
                    children: <Widget>[
                        appBar,
                        Expanded(child: pageView)
                    ],
                ),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.create),
                onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewMessage()),
                    );
                },
            ),
        );
    }
}
