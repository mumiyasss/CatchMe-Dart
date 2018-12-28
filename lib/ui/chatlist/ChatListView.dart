import 'package:catch_me/ui/chatlist/ChatListLogic.dart';
import 'package:catch_me/ui/chatscreen/ChatScreenView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:catch_me/values/Dimens.dart';
import 'package:catch_me/values/Styles.dart';
import 'ChatListItemModel.dart';

class ChatListView extends ChatListLogic {
  static final profilePicture1 = AssetImage('assets/hi.png');
  
  Widget profilePicture(BuildContext context, String photo) {
    double size = MediaQuery.of(context).size.width *
        Dimens.chatListProfilePictureProportion;
    return photo == null
        ? SvgPicture.asset(
            'assets/profile.svg',
            width: size,
            height: size,
          )
        : Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: AssetImage('assets/hi.png'))),
            //child: profilePhoto
          );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.only(
            left: Dimens.chatListPadding, right: Dimens.chatListPadding),
        children: super
            .messages
            .map((message) => _buildListItem(
                context,
                ChatListItemModel(
                    name: message['name'],
                    message: message['message'],
                    time: message['time'],
                    unread: message['unread'],
                    photo: message['photo'])))
            .toList(),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, ChatListItemModel chat) {
    var profilePhoto = profilePicture(context, chat.photo);

    Container wrappedText(
            String text, TextStyle style, double screenPercentage) =>
        Container(
            width: MediaQuery.of(context).size.width * screenPercentage,
            child: Text(
              text,
              style: style,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ));

    Row messageRow(Widget widget1, Widget widget2) => Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[widget1, widget2],
        );

    var name = wrappedText(chat.name, Style.chatNameStyle(), 0.5);
    var time = Text(chat.time, style: Style.lastMessageTime());
    var lastMessage = wrappedText(chat.message, Style.lastMessageTime(), 0.5);
    var _unread = chat.unread;
    var badge = _unread == null
        ? Container()
        : Container(
            padding: EdgeInsets.fromLTRB(7.2, 3, 7.2, 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Color(0xFF2196f3),
            ),
            child: Text(_unread.toString(), style: Style.newMessagesCounter()),
          );

    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreenView()),
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
                        messageRow(name, time),
                        Container(
                          height: 3,
                        ),
                        messageRow(lastMessage, badge)
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
}
