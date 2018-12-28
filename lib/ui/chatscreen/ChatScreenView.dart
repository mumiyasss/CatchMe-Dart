import 'package:catch_me/values/Dimens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  @override
  Widget build(BuildContext context) {
    final backButton = GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: SvgPicture.asset(
          'assets/ic_back.svg',
          width: 20,
          height: 20,
        ));

    final menuButton = SvgPicture.asset(
      'assets/ic_hamm.svg',
      width: 20,
      height: 20,
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
      children: snapshot
          .map((data) => _buildMessageBubble(context, false, data))
          .toList(),
    ),
  );
}

Widget _buildMessageBubble(
    BuildContext context, bool self, DocumentSnapshot data) {
  final message = Message.fromSnapshot(data);

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
      // textAlign: self ? TextAlign.end : TextAlign.start,
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
        var data = {'text': controller.text, 'author': ""};
        Firestore.instance
            .collection('chats/CPTxvAPRNjLDpUMs96nD/messages')
            .add(data);
        controller.text = "";
        }
      },
      child: SvgPicture.asset(
        'assets/ic_send.svg',
        width: Dimens.messageFieldButtonWidth,
      ));
  static final attach = SvgPicture.asset(
    'assets/ic_attach.svg',
    width: Dimens.messageFieldButtonWidth,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 18),
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
            ),
            actionButton
          ],
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final String author;
  final DocumentReference reference;

  Message.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['text'] != null),
        assert(map['author'] != null),
        text = map['text'],
        author = map['author'];

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$text:$author>";
}
