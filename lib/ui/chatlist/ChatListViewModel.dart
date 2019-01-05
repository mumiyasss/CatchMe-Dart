import 'dart:async';

import 'package:catch_me/main.dart';
import 'package:catch_me/models/Chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListViewModel {
  Stream<QuerySnapshot> get chatsCollection => Firestore.instance
      .collection('chats')
      .where('members', arrayContains: CatchMeApp.userUid)
      .orderBy('lastMessageTime', descending: true ) // ??? Query requires Index.
      .snapshots();

  Stream<List<Chat>> get chats async* {
    await for (var chats in chatsCollection) {
      var tempChatList = List<Chat>();
      for (var chatSnapshot in chats.documents)
        tempChatList.add(await Chat.fromSnapshot(chatSnapshot));
      yield tempChatList;
    }
  }
}
