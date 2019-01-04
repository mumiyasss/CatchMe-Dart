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

  static String getCompanionId(List members) {
    print(members);
    for (var memberId in members) {
      if (memberId != CatchMeApp.userUid) return memberId;
    }
    return "";
  }

  static Future<UiChat> fromSnapshot(DocumentSnapshot chatSnapshot) async {
    UiChat chat = UiChat();
    chat.chatReference = chatSnapshot.reference;
    chat.time = "12:30";
    chat.message = chatSnapshot.data['lastMessageText'];
    chat.unread = null;
    var companionId = getCompanionId(chatSnapshot.data['members']);
    chat.photo = await getPersonPhoto(companionId);
    chat.name = updateChatName(companionId);
    return chat;
  }
}
