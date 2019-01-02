import 'dart:async';

import 'package:catch_me/models/UiChat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListViewModel {
  Stream<QuerySnapshot> get chatsCollection => Firestore.instance
      .collection('chats')
      //.where('members', arrayContains: CatchMeApp.userId)
      //.orderBy('lastMessage')
      .snapshots();

  Stream<List<UiChat>> get chats async* {
    await for (var chats in chatsCollection) {
      yield chats.documents
          .map((chatSnapshot) => UiChat.fromSnapshot(chatSnapshot))
          .toList();
    }
  }
}
