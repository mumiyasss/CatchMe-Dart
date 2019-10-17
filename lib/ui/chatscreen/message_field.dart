import 'dart:io';

import 'package:catch_me/bloc/chat_screen/messages_panel/bloc.dart';
import 'package:catch_me/bloc/chat_screen/messages_panel/events.dart';
import 'package:catch_me/bloc/chat_screen/sending_messages/bloc.dart';
import 'package:catch_me/bloc/chat_screen/sending_messages/events.dart';
import 'package:catch_me/bloc/chat_screen/sending_messages/states.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Person.dart';
import 'package:catch_me/values/Dimens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class MessageSendingWidget extends StatelessWidget {
    final SendingMessagesBloc bloc;

    MessageSendingWidget(this.bloc);

    @override
    Widget build(BuildContext context) {
        return Column(
            children: <Widget>[
                StreamBuilder(
                    stream: SendingMessagesBloc.imageQuantityStreamController.stream,
                    builder: (context, AsyncSnapshot<int> snapshot) {
                        return ImagesUploadIndicator(snapshot.data ?? 0);
                    }
                ),
                MessageField(bloc),
            ]
        );
    }
}

class ImagesUploadIndicator extends StatelessWidget {
    final int quantity;

    ImagesUploadIndicator(this.quantity);

    @override
    Widget build(BuildContext context) {
        return AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            height: quantity > 0 ? 40 : 0,
            child: Container(
                child: Row(children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 20, right: 13),
                        height: 25,
                        width: 50,
                        child: FlareActor(
                            'assets/upload_image_indicator.flr',
                            isPaused: quantity == 0,
                            animation: 'Play',
                        ),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 4),
                        child: Text(App.lang.photoUploadingIndicator(quantity),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue
                            ),
                        ),
                    ),
                ],
                ),
            )
        );
    }
}

class MessageField extends StatefulWidget {
    final SendingMessagesBloc bloc;

    MessageField(this.bloc);

    _MessageFieldState createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
    final _controller = TextEditingController();

    _AttachButton attach;
    _SendButton send;
    _ActionButton actionButton;

    @override
    void initState() {
        send = _SendButton(_controller, widget.bloc);
        actionButton = attach = _AttachButton(widget.bloc);
        _controller.addListener(updateActionButton);
        super.initState();
    }

    updateActionButton() {
        _controller.text.length == 0
            ? setState(() =>
        actionButton = attach)
            : setState(() =>
        actionButton = send);
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            height: Dimens.messageFieldHeight,
            decoration: BoxDecoration(
                color: Colors.white, boxShadow: [
                BoxShadow(
                    offset: Offset(0, -2),
                    blurRadius: 0,
                    color: Color(0x22000000))
            ]),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween,
                    children: <Widget>[
                        Expanded(
                            child: TextField(
                                controller: _controller,
                                keyboardType: TextInputType
                                    .text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: App.lang.typeYourMessageHere),
                                textCapitalization: TextCapitalization
                                    .sentences,
                            ),
                        ),
                        actionButton
                    ],
                ),
            ),
        );
    }
}

abstract class _ActionButton extends StatelessWidget {
    @override
    Widget build(BuildContext context) =>
        GestureDetector(
            onTap: onTap,
            child: icon
        );

    void onTap();

    Widget get icon;
}

class _SendButton extends _ActionButton {
    final TextEditingController _messageField;
    final SendingMessagesBloc _bloc;

    _SendButton(this._messageField, this._bloc);

    @override
    Widget build(BuildContext context) {
        return super.build(context);
    }

    @override
    void onTap() {
        final message = _messageField.text;
        if (message.length > 0) {
            _bloc.dispatch(WriteNewTextMessageEvent(message));
            _messageField.clear();
        }
    }

    @override
    Icon get icon =>
        Icon(
            Icons.send,
            size: Dimens.messageFieldButtonWidth,
        );
}

class _AttachButton extends _ActionButton {
    final SendingMessagesBloc _bloc;

    _AttachButton(this._bloc);

    @override
    Widget get icon =>
        Transform.rotate(
            angle: 3.14 / 4 * 5,
            child: Icon(
                Icons.attach_file,
                size: Dimens.messageFieldButtonWidth,
            ),
        );

    @override
    void onTap() async {
        _bloc.dispatch(AttachImageEvent());
    }
}
