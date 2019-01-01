import 'package:catch_me/models/Message.dart';
import 'package:catch_me/values/Dimens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

String userId;

class ChatScreenView extends StatelessWidget {
  final title = Row(
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 18),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage('assets/hi.png'))),
        //child: profilePhoto
      ),
      Padding(
        padding: const EdgeInsets.only(
          left: 12.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("James Smith", style: TextStyle(fontSize: 20)),
            Text(
              'last seen at 8:30',
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
      ),
    ],
  );

  void initUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userId = await user.getIdToken();
  }

  @override
  Widget build(BuildContext context) {
    initUser();
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
      //height: 55,
      padding: EdgeInsets.symmetric(horizontal: 26, vertical: 8),
      margin: EdgeInsets.only(bottom: 2),
      //color: Color(0x22000000),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(offset: Offset(0, 2), blurRadius: 5, color: Color(0x22000000))
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[backButton, Expanded(child: title), menuButton],
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
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('chats/CPTxvAPRNjLDpUMs96nD/messages')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return LinearProgressIndicator();
                      return _buildList(context, snapshot.data.documents);
                    },
                  )),
            ),
            MessageField()
          ],
        ),
      ),
    );
  }
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return Container(
    color: Colors.white,
    child: ListView(
      reverse: true,
      children:
          snapshot.map((data) => _buildMessageBubble(context, data)).toList(),
    ),
  );
}

Widget _buildMessageBubble(BuildContext context, DocumentSnapshot data) {
  print(data.data.toString());
  
  final message = Message.fromSnapshot(data);
  bool self = message.author == userId;
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
      onTap: () async {
        if (controller.text.length > 0) {
          var data = {
            'text': controller.text,
            'author': userId,
            'timestamp': Timestamp.now()
          };
          Firestore.instance
              .collection('chats/CPTxvAPRNjLDpUMs96nD/messages')
              .add(data);
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
