import 'package:catch_me/bloc/chat_screen/chat_info/bloc.dart';
import 'package:catch_me/bloc/chat_screen/messages_panel/bloc.dart';
import 'package:catch_me/bloc/chat_screen/messages_panel/states.dart';
import 'package:catch_me/bloc/chat_screen/sending_messages/bloc.dart';
import 'package:catch_me/models/Message.dart';
import 'package:catch_me/ui/chatscreen/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bubble.dart';
import 'message_field.dart';
import 'app_bar.dart';

class ChatScreen extends StatelessWidget {
    final MessagesBloc _bloc;
    final DocumentReference _chatReference;

    ChatScreen(this._chatReference) :
            _bloc = MessagesBloc(_chatReference) {

    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                        MyAppBar(ChatBloc(_chatReference)), // todo: wrong>
                        Flexible(
                            child: GestureDetector(
                                onTap: () =>
                                    FocusScope.of(context).requestFocus(
                                        FocusNode()),
                                child: BlocBuilder( // ToDo: maybe bloc listener?
                                    bloc: _bloc,
                                    builder: (BuildContext context, ChatScreenState state) {
                                        if (state is MessagesAreLoading) {
                                            return CircularProgressIndicator();
                                        }
                                        if (state is MessagesAreLoaded) {
                                            return MessagesList(state.messages);
                                        }
                                    }

                                ),
                            ),
                        ),
                        MessageField(SendingMessagesBloc(_chatReference))
                    ],
                ),
            ),
        );
    }
}


// Todo: необходима обработка пустого диалога
class MessagesList extends StatelessWidget {
    final List<Message> _messages;

    MessagesList(this._messages);

    @override
    Widget build(BuildContext context) {
        return Container(
            color: Colors.white,
            child: ListView(
                reverse: true,
                children:
                _messages.map((message) => MessageBubble(message)).toList(),
            ),
        );
    }
}
