import 'package:catch_me/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UiChat {
  final Stream<String> name;
  final message;
  final String time;
  final int unread;
  final String photo;
  final DocumentReference chatReference;

  static Stream<String> updateChatName(String userId) async* {
    await for (var user
        in Firestore.instance.collection('users').document(userId).snapshots()) {
      if (user.exists)
        yield user.data['name'];
      else print(userId);
    }
  }

  UiChat.fromMap(Map<String, dynamic> data, this.chatReference)
      : assert(data['lastMessageTime'] != null),
        //assert(data['lastMessage'] != null),
        name = updateChatName(data['talkWithFor'+CatchMeApp.userUid]),
        time = "12:30",
        message = data['lastMessageText'],
        photo = ",",
        unread = null;

  UiChat.fromSnapshot(DocumentSnapshot chatSnapshot)
      : this.fromMap(chatSnapshot.data, chatSnapshot.reference);
}
