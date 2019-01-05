import 'package:catch_me/models/Chat.dart';
import 'package:catch_me/ui/Widgets.dart';
import 'package:catch_me/ui/chatlist/ChatListViewModel.dart';
import 'package:catch_me/ui/chatscreen/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:catch_me/values/Dimens.dart';
import 'package:catch_me/values/Styles.dart';

final viewModel = ChatListViewModel();

class ChatList extends StatelessWidget {
  static final profilePicture1 = AssetImage('assets/hi.png');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StreamBuilder(
            stream: viewModel.chats,
            builder: (context, snapshot) =>
                _buildList(context, snapshot.data)));
  }

  Widget _buildList(BuildContext context, List<Chat> chats) {
    if (chats != null && chats.length != 0)
      return ListView(
        padding: EdgeInsets.only(
            left: Dimens.chatListPadding, right: Dimens.chatListPadding),
        children: chats.map((chat) => _buildListItem(context, chat)).toList(),
      );
    else
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
        Text(
          "У вас пока нет сообщений.",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w300),
        ),
        Container(height: 7,),
        Text(
          "Напишите первыми😏",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
        ),
      ]));
  }

  Widget _buildListItem(BuildContext context, Chat chat) {
    var profilePhoto = Widgets.profilePicture(
        context, chat.photo, Dimens.chatListProfilePictureProportion);

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

    var name = wrappedText(chat.name, Styles.chatNameStyle(), 0.5);
    var time = Text(chat.time, style: Styles.lastMessageTime());
    var lastMessage = wrappedText(chat.message, Styles.lastMessageTime(), 0.5);
    var _unread = chat.unread;
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
                builder: (context) => ChatScreen(chat.chatReference)),
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
