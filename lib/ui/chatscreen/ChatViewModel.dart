import 'dart:async';

import 'package:catch_me/main.dart';
import 'package:catch_me/models/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatViewModel {
  ChatViewModel(this._chatReference);

  final userId = CatchMeApp.userUid;
  final DocumentReference _chatReference;
  CollectionReference get _chatMessageCollection =>
      _chatReference.collection('messages');

  Stream<QuerySnapshot> get _messagesDocumentSnapshots =>
      _chatMessageCollection.orderBy('timestamp', descending: true).snapshots();

  Stream<List<Message>> get messagesSnapshot async* {
    await for (var snapshot in _messagesDocumentSnapshots)
      yield snapshot.documents
          .map((data) => Message.fromSnapshot(data))
          .toList();
  }

  void sendMessage(String text) async {
    var data = {'text': text, 'author': userId, 'timestamp': Timestamp.now()};
    Firestore.instance
        .collection('chats/CPTxvAPRNjLDpUMs96nD/messages')
        .add(data);
  }
}
