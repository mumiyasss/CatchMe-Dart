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
            Center(
              child: RaisedButton(
                  child: new Text('dismiss'),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    SingleChildScrollView();
                  }),
            ),
            MessageField()
          ],
        ),
      ),
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
