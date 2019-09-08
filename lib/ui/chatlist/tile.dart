import 'package:catch_me/models/Chat.dart';
import 'package:catch_me/ui/chatscreen/chat_screen.dart';
import 'package:catch_me/utils.dart';
import 'package:catch_me/values/Dimens.dart';
import 'package:catch_me/values/Styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Widgets.dart';

class ChatTile extends StatelessWidget {
    final Chat _chat;

    ChatTile(this._chat);

    @override
    Widget build(BuildContext context) {
        var profilePhoto = Widgets.profilePicture(
            context, _chat.companion.photoUrl, Dimens.chatListProfilePictureProportion);
        var name = _wrappedText(context, _chat.companion.name, Styles.chatNameStyle(), 0.5);
        var time = Text(toReadableTime(_chat.time), style: Styles.lastMessageTime());
        var lastMessage = _wrappedText(context, _chat.message, Styles.lastMessageTime(), 0.5);
        var _unread = _chat.unread;
        var badge = _unread == null
            ? Container()
            : Container(
            padding: EdgeInsets.fromLTRB(7.2, 3, 7.2, 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Color(0xFF2196f3),
            ),
            child: Text(_unread.toString(), style: Styles.newMessagesCounter()),
        );

        return GestureDetector(
            onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(_chat.companion)),
                );
            },
            child: Column(
                children: <Widget>[
                    Row(
                        children: <Widget>[
                            profilePhoto,
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(left: 18),
                                    child: Column(
                                        children: <Widget>[
                                            _messageRow(name, time),
                                            Container(
                                                height: 3,
                                            ),
                                            _messageRow(lastMessage, badge)
                                        ],
                                    ),
                                ),
                            ),
                        ],
                    ),
                    Divider()
                ],
            ));
    }

    Container _wrappedText(BuildContext context,
        String text, TextStyle style, double screenPercentage) =>
        Container(
            width: MediaQuery.of(context).size.width * screenPercentage,
            child: Text(
                text,
                style: style,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
            ));

    Row _messageRow(Widget widget1, Widget widget2) => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[widget1, widget2],
    );
}

