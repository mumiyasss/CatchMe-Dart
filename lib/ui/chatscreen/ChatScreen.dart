import 'package:catch_me/models/Message.dart';
import 'package:catch_me/models/UiPerson.dart';
import 'package:catch_me/ui/Widgets.dart';
import 'package:catch_me/ui/chatscreen/ChatViewModel.dart';
import 'package:catch_me/ui/chatscreen/title.dart';
import 'package:catch_me/values/Dimens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'bubble.dart';
import 'message_field.dart';

ChatViewModel viewModel;

class ChatScreen extends StatelessWidget {
    ChatScreen(DocumentReference chatReference) {
        viewModel = ChatViewModel(chatReference);
    }

    _buildTitle(BuildContext context) =>
        FutureBuilder<Person>(
            future: viewModel.getChatInfo(),
            builder: (context, snapshot) =>
            snapshot.hasData
                ? TopBar(snapshot.data)
                : LinearProgressIndicator(),
        );

    @override
    Widget build(BuildContext context) {
        final backButton = GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: SvgPicture.asset(
                'assets/ic_back.svg',
                width: 20,
                height: 20,
            ));

        final menuButton = Icon(
            Icons.menu,
            size: 25,
        );

        final appBar = Container(
            padding: EdgeInsets.symmetric(horizontal: 26, vertical: 8),
            margin: EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(offset: Offset(0, 2),
                    blurRadius: 5,
                    color: Color(0x22000000))
            ]),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                    backButton,
                    Expanded(child: _buildTitle(context)),
                    menuButton
                ],
            ),
        );

        return Scaffold(
            body: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                        appBar,
                        Flexible(
                            child: GestureDetector(
                                onTap: () =>
                                    FocusScope.of(context).requestFocus(
                                        new FocusNode()),
                                child: StreamBuilder<List<Message>>(
                                    stream: viewModel.messagesSnapshot,
                                    builder: (context, snapshot) =>
                                    snapshot.hasData
                                        ? _buildList(context, snapshot.data)
                                        : LinearProgressIndicator(),
                                )),
                        ),
                        MessageField()
                    ],
                ),
            ),
        );
    }
}

Widget _buildList(BuildContext context, List<Message> messages) {
    return Container(
        color: Colors.white,
        child: ListView(
            reverse: true,
            children:
            messages.map((message) => MessageBubble(message)).toList(),
        ),
    );
}
