import 'dart:async';

import 'package:catch_me/ui/writeToNewPerson/NewMessage.dart';
import 'package:flutter/material.dart';
import 'package:catch_me/ui/chatlist/ChatList.dart';
import 'package:catch_me/ui/settings/Settings.dart';
import 'AppBar.dart';
import 'package:catch_me/values/Dimens.dart';

class MainPage extends StatelessWidget {
  final pageView = PageView(
    physics: AlwaysScrollableScrollPhysics(),
    children: <Widget>[
      ChatList(),
      Settings(),
    ],
  );

  // var counter = 0;
  // void fun() async {
  //   print(pageView.controller.toString()+" "+(counter++).toString());
  //   await Future.delayed(Duration(seconds: 1));
  //   fun();
  // }


  void plugPositionListener() {
    if (!pageView.controller.hasClients) {
      Future.delayed(Duration(milliseconds: 500)).then((_) {
        plugPositionListener();
      });
    } else {
      pageView.controller.position.addListener(_pageViewListener);
    }
  }

  static final pageViewStreamController = StreamController<double>.broadcast(sync: true);
  void _pageViewListener() {
    pageViewStreamController.add(pageView.controller.position.pixels);
  }

  @override
  Widget build(BuildContext context) {
    var appBar = MyAppBar(pageViewStreamController);
    // fun();
    plugPositionListener();
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          appBar,
          Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: Dimens.appBarHeight),
              child: pageView)
        ],
      )),
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
