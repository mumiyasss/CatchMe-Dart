import 'package:catch_me/main.dart';
import 'package:catch_me/models/UiPerson.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UiChat {
  String name;
  String message;
  String time;
  int unread;
  String photo;
  DocumentReference chatReference;

  static Future<UiChat> fromSnapshot(DocumentSnapshot chatSnapshot) async {
    UiChat chat = UiChat();
    chat.chatReference = chatSnapshot.reference;

    var dateTime = (chatSnapshot.data['lastMessageTime'] as DateTime);
    chat.time = dateTime.hour.toString() + ':' + dateTime.minute.toString();

    chat.message = chatSnapshot.data['lastMessageText'];
    chat.unread = null;
    var companion =
        await UiPerson.fromPrivateChatMembers(chatSnapshot.data['members']);
    chat.photo = companion.photoUrl;
    chat.name = companion.name;
    return chat;
  }
}
