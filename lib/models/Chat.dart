import 'package:catch_me/main.dart';
import 'package:catch_me/models/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chat {
  String name;
  String message;
  String time;
  int unread;
  String photo;
  DocumentReference chatReference;

  static Future<Chat> fromSnapshot(DocumentSnapshot chatSnapshot) async {
    Chat chat = Chat();
    chat.chatReference = chatSnapshot.reference;

    var timeStamp = (chatSnapshot.data['lastMessageTime'] as Timestamp);
    chat.time = timeStamp.toDate().hour.toString() + ':' + timeStamp.toDate().minute.toString();

    chat.message = chatSnapshot.data['lastMessageText'];
    chat.unread = null;
    var companion =
        await Person.fromPrivateChatMembers(chatSnapshot.data['members']);
    chat.photo = companion.photoUrl;
    chat.name = companion.name;
    return chat;
  }
}
