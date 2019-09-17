import 'package:catch_me/bloc/chat_screen/chat_info/bloc.dart';
import 'package:catch_me/bloc/chat_screen/messages_panel/bloc.dart';
import 'package:catch_me/bloc/chat_screen/messages_panel/states.dart';
import 'package:catch_me/bloc/chat_screen/sending_messages/bloc.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Chat.dart';
import 'package:catch_me/models/Message.dart';
import 'package:catch_me/models/Person.dart';
import 'package:catch_me/ui/chatscreen/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'bubble.dart';
import 'message_field.dart';
import 'app_bar.dart';

class ChatScreen extends StatelessWidget {
    final ChatBloc _chatBloc;

//    Chat _chat;

//    ChatScreen(this._chat) :
//            _bloc = MessagesBloc(_chat.reference);

    final Observable<Person> _personStream;
    final Person person;
    final SendingMessagesBloc _sendingBloc;

    ChatScreen(this.person)
        :   _personStream = CatchMeApp.personDao.fromUserId(person.userId),
            _chatBloc = ChatBloc(person),
            _sendingBloc = SendingMessagesBloc(person);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                        Expanded(
                            child: Stack(children: <Widget>[
                                MessagesPanel(_chatBloc),
                                MyAppBar(_chatBloc),
                            ],
                            ),
                        ),

                        MessageSendingWidget(_sendingBloc)
                    ],
                ),
            ),
        );
    }
}

class LoadingFlareActor extends StatelessWidget {
    final double persentage;

    LoadingFlareActor(this.persentage);

    @override
    Widget build(BuildContext context) {
        return Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.3,
            height: MediaQuery
                .of(context)
                .size
                .width * 0.3,
            child:
            FlareActor(
                'assets/loading.flr',
                shouldClip: false,
                animation: 'Aura', // or Aura2
            ));
    }
}

class MessagesPanel extends StatelessWidget {

    final ChatBloc _chatBloc;

    MessagesPanel(this._chatBloc);

    @override
    Widget build(BuildContext context) {
        return Container(
            margin: EdgeInsets.only(top: 60),
            child: FocusSwitcher(
                child: StreamBuilder<DocumentSnapshot>(
                    stream: _chatBloc.chatSnapshots,
                    builder: (context, snapshot) {
                        var chatSnapshot = snapshot.data;
                        if (snapshot.hasData && chatSnapshot.data != null) {
                            return BlocBuilder(
                                bloc: MessagesBloc(chatSnapshot.reference),
                                builder: (context, ChatScreenState state) {
                                    if (state is MessagesAreLoading) {
                                        return Center(
                                            child: LoadingFlareActor(0.3)
                                        );
                                    }
                                    if (state is MessagesAreLoaded) {
                                        return MessagesList(state.messages);
                                    }
                                    throw Exception(
                                        ['No such state in Mes Panel']);
                                });
                        } else { // todo : make nice...
                            return Center(child: Text("No Messages yet"),);
                        }
                    }
                ),
            ),
        );
    }
}

/// For keyboard
class FocusSwitcher extends StatelessWidget {
    final Widget child;

    FocusSwitcher({@required this.child});

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () =>
                FocusScope.of(context).requestFocus(
                    FocusNode()),
            child: this.child);
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
                children: [
                    ..._messages.map((message) => MessageBubble(message))
                        .toList(),
                    ...List() // space upper first message
                        ..add(Container(height: 16,)),
                ],
            ),
        );
    }
}
