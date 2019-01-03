import 'package:catch_me/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UiChat {
  Stream<String> name;
  String message;
  String time;
  int unread;
  String photo;
  DocumentReference chatReference;

  static Stream<String> updateChatName(String userId) async* {
    await for (var user in Firestore.instance
        .collection('users')
        .document(userId)
        .snapshots()) {
      if (user.exists)
        yield user.data['name'];
      else
        print(userId);
    }
  }

  static Future<String> getPersonPhoto(String userId) async {
    var user =
        await Firestore.instance.collection('users').document(userId).get();
    return user.data['photo'];
  }

  static Future<UiChat> fromSnapshot(DocumentSnapshot chatSnapshot) async {
    UiChat chat = UiChat();
    chat.chatReference = chatSnapshot.reference;
    chat.time = "12:30";
    chat.message = chatSnapshot.data['lastMessageText'];
    chat.photo = await getPersonPhoto(
        chatSnapshot.data['talkWithFor' + CatchMeApp.userUid]);
    chat.unread = null;
    chat.name =
        updateChatName(chatSnapshot.data['talkWithFor' + CatchMeApp.userUid]);
    return chat;
  }
}
