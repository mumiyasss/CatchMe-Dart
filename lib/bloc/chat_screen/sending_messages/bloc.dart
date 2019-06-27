import 'package:bloc/bloc.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Message.dart';
import 'package:catch_me/models/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'events.dart';
import 'states.dart';

class SendingMessagesBloc extends Bloc<NewMessageEvent, MessageSent> {
    final DocumentReference _chatReference;

    SendingMessagesBloc(this._chatReference);

    @override
    MessageSent get initialState => MessageSent();

    @override
    Stream<MessageSent> mapEventToState(NewMessageEvent event) async* {
        if (event is WriteNewTextMessageEvent) {
            await _sendMessage(event.message);
            yield MessageSent();
        }
    }

    _sendMessage(String text) async {
        var data = {
            'text': text,
            'author': CatchMeApp.userUid,
            'timestamp': Timestamp.now()
        };
        _chatReference.collection('messages').add(data);
        _chatReference.updateData({
            'lastMessageAuthorId': CatchMeApp.userUid,
            'lastMessageText': text,
            'lastMessageTime': Timestamp.now()
        });
    }
}