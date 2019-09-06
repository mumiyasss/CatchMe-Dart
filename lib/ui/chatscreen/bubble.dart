import 'package:cached_network_image/cached_network_image.dart';
import 'package:catch_me/models/Message.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class MessageBubble extends StatelessWidget {

    final Message _message;

    MessageBubble(this._message);

    @override
    Widget build(BuildContext context) {
        bool self = _message.author == CatchMeApp.userUid;
        var bigMargin = MediaQuery
            .of(context)
            .size
            .width * 0.3;
        var bottomMargin = 9.0;

        var messageBubble = (_message.imageUrl == null) ?
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: Color(self ? 0xFFCECECE : 0)),
                color: Color(self ? 0xFFFFFFFF : 0xFF2196F3),
            ),
            child: Text(
                _message.text,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: self ? Colors.black : Colors.white),
            ),

        ) : Container(
            height: 200,
            child: CachedNetworkImage(
                imageUrl: _message.imageUrl,
                imageBuilder: (context, imageProvider) =>
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            //border: Border.all(color: Color(self ? 0xFFCECECE : 0)),
                            color: Color(self ? 0xFFFFFFFF : 0xFF2196F3),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: imageProvider
                            ),
                        ),
                    ),
                placeholder: (context, url) =>
                    Container(
                        width: 266,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: Color(self ? 0xFFCECECE : 0)),
                            color: Color(self ? 0xFFFFFFFF : 0xFF2196F3),
                        ),
                        child: Center(child: CircularProgressIndicator()),
                    ),

            ),
        );

        return Container(
            padding: self
                ? EdgeInsets.only(
                left: bigMargin, right: 10, bottom: bottomMargin)
                : EdgeInsets.only(
                right: bigMargin, left: 10, bottom: bottomMargin),
            alignment: self ? Alignment.centerRight : Alignment.centerLeft,
            child: messageBubble,
        );
    }
}
