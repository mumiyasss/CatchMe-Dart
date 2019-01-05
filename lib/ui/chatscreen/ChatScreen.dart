import 'package:catch_me/models/Message.dart';
import 'package:catch_me/models/UiPerson.dart';
import 'package:catch_me/ui/Widgets.dart';
import 'package:catch_me/ui/chatscreen/ChatViewModel.dart';
import 'package:catch_me/values/Dimens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

ChatViewModel viewModel;

class ChatScreen extends StatelessWidget {
  ChatScreen(DocumentReference chatReference) {
    viewModel = ChatViewModel(chatReference);
  }
  Widget title(context, UiPerson person) => Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 18),
            width: 40,
            height: 40,
            // decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     image: DecorationImage(image: NetworkImage(person.photoUrl))),
            child: Widgets.profilePicture(context, person.photoUrl, 0.01)
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(person.name, style: TextStyle(fontSize: 20)),
                Text(
                  'last seen at 8:30',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
        ],
      );

  Widget _buildTitle(BuildContext context) => FutureBuilder<UiPerson>(
        future: viewModel.getChatInfo(),
        builder: (context, snapshot) => snapshot.hasData
            ? title(context, snapshot.data)
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
        BoxShadow(offset: Offset(0, 2), blurRadius: 5, color: Color(0x22000000))
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[backButton, Expanded(child: _buildTitle(context)), menuButton],
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
                      FocusScope.of(context).requestFocus(new FocusNode()),
                  child: StreamBuilder<List<Message>>(
                    stream: viewModel.messagesSnapshot,
                    builder: (context, snapshot) => snapshot.hasData
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
          messages.map((data) => _buildMessageBubble(context, data)).toList(),
    ),
  );
}

Widget _buildMessageBubble(BuildContext context, Message message) {
  bool self = message.author == viewModel.userId;
  var bigMargin = MediaQuery.of(context).size.width * 0.3;
  var bottomMargin = 9.0;

  var messageBubble = Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      border: Border.all(color: Color(self ? 0xFFCECECE : 0)),
      color: Color(self ? 0xFFFFFFFF : 0xFF2196F3),
    ),
    child: Text(
      message.text,
      textAlign: TextAlign.justify,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: self ? Colors.black : Colors.white),
    ),
  );

  return Container(
    padding: self
        ? EdgeInsets.only(left: bigMargin, right: 10, bottom: bottomMargin)
        : EdgeInsets.only(right: bigMargin, left: 10, bottom: bottomMargin),
    alignment: self ? Alignment.centerRight : Alignment.centerLeft,
    child: messageBubble,
  );
}

class MessageField extends StatefulWidget {
  _MessageFieldState createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  static final send = GestureDetector(
      onTap: () {
        if (controller.text.length > 0) {
          viewModel.sendMessage(controller.text);
          controller.text = "";
        }
      },
      child: Icon(
        Icons.send,
        size: Dimens.messageFieldButtonWidth,
      ));
  static final attach = Icon(
    Icons.attach_file,
    size: Dimens.messageFieldButtonWidth,
  );

  static final controller = TextEditingController();
  Widget actionButton = attach;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: Dimens.messageFieldHeight,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              offset: Offset(0, -2), blurRadius: 0, color: Color(0x22000000))
        ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.text,
                  onChanged: (text) {
                    text.length == 0
                        ? setState(() => actionButton = attach)
                        : setState(() => actionButton = send);
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Type your message"),
                ),
              ),
              actionButton
            ],
          ),
        ),
      ),
    );
  }
}
