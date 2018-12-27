import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: GestureDetector(
                onTap: () =>
                    FocusScope.of(context).requestFocus(new FocusNode()),
                child: Container(
                  height: 600,
                  child: ListView(
                    reverse: true,
                    children: <Widget>[
                      MessageBubble(false, "Hello"),
                      MessageBubble(true, "Hello"),
                      MessageBubble(
                          false, "Hello, how are you, buddy? I heard "),
                      MessageBubble(false,
                          "Hello, how are you, buddy? I heard a lot about you!!!"),
                      MessageBubble(true,
                          "Hello, how are you, buddy? I heard a lot about you!!!"),
                      MessageBubble(true,
                          "Hello, how are you, buddy? I heard a lot about you!!!"),
                      MessageBubble(true,
                          "Hello, how are you, buddy? I heard a lot about you!!!"),
                      MessageBubble(false,
                          "Hello, how are you, buddy? I heard a lot about you!!!"),
                      MessageBubble(true,
                          "Hello, how are you, buddy? I heard a lot about you!!!"),
                      MessageBubble(false,
                          "Hello, how are you, buddy? I heard a lot about you!!!"),
                    ],
                  ),
                ),
              ),
            ),
            MessageField()
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(this.self, this.text);
  final bool self;
  final String text;

  @override
  Widget build(BuildContext context) {
    var bigMargin = MediaQuery.of(context).size.width * 0.3;
    var bottomMargin = 9.0;

    var message = Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: Color(0xFFCECECE)),
        color: self ? Color(0xFFFFFFFF) : Color(0xFF2196F3),
      ),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        // textAlign: self ? TextAlign.end : TextAlign.start,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: self ? Colors.black : Colors.white),
      ),
    );

    return Container(
      padding: self
          ? EdgeInsets.only(left: bigMargin, right: 10, bottom: bottomMargin)
          : EdgeInsets.only(right: bigMargin, left: 10, bottom: bottomMargin),
      alignment: self ? Alignment.centerRight : Alignment.centerLeft,
      child: message,
    );
  }
}

class MessageField extends StatefulWidget {
  _MessageFieldState createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  static final send = SvgPicture.asset(
    'assets/ic_send.svg',
    height: 80,
    width: 80,
  );
  static final attach = SvgPicture.asset(
    'assets/ic_attach.svg',
    height: 80,
    width: 80,
  );

  var actionButton = attach;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: 50,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              offset: Offset(0, -2), blurRadius: 0, color: Color(0x22000000))
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: TextField(
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
            actionButton,
          ],
        ),
      ),
    );
  }
}
