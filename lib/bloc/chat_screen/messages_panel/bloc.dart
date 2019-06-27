import 'package:bloc/bloc.dart';
import 'package:catch_me/models/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'events.dart';
import 'states.dart';

class MessagesBloc extends Bloc<ChatScreenEvent, ChatScreenState> {
    final DocumentReference _chatReference;
    Stream<QuerySnapshot> _messagesDocumentSnapshots;

    MessagesBloc(this._chatReference) {
        _messagesDocumentSnapshots =
            _chatReference
                .collection('messages')
                .orderBy('timestamp', descending: true)
                .snapshots();
    }

    @override
    ChatScreenState get initialState => MessagesAreLoading();

    @override
    Stream<ChatScreenState> mapEventToState(ChatScreenEvent event) async* {
        if (event is StartListenNewMessages) {
            await for (var snapshot in _messagesDocumentSnapshots) {
                var listOfMessages = snapshot.documents
                    .map((document) => Message.fromSnapshot(document))
                    .toList();
                yield MessagesAreLoaded(listOfMessages);
            }
        }
    }
}
