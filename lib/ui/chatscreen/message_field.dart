import 'package:catch_me/values/Dimens.dart';
import 'package:flutter/material.dart';

class MessageField extends StatefulWidget {
    _MessageFieldState createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
    static final send = GestureDetector(
        onTap: () {
            if (controller.text.length > 0) {
                // TODO: sendMessage
                //viewModel.sendMessage(controller.text);
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
