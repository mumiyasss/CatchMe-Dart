import 'package:catch_me/main.dart';
import 'package:catch_me/models/UiPerson.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessageViewModel {
  Stream<QuerySnapshot> get _usersCollection =>
      Firestore.instance.collection('users').snapshots();

  Stream<List<UiPerson>> get users async* {
    await for (var users in _usersCollection) {
      yield users.documents
          .map((userSnapshot) => UiPerson.fromSnapshot(userSnapshot))
          .toList();
    }
  }

  Future<DocumentReference> startNewConversation(String companionId) async {
    final members = List<String>();
    members.add(companionId);
    members.add(CatchMeApp.userUid);
    var chat = await Firestore.instance
        .document('chats/' + chatName(companionId, CatchMeApp.userUid))
        .get();

    if (chat.exists == false) {
      final tempMessages = List<String>();
      tempMessages.add("Conversation Started");
      Firestore.instance
          .collection('chats')
          .document(chatName(companionId, CatchMeApp.userUid))
          .setData({
        'members': members,
        'lastMessageText': "Hello",
        'lastMessageAuthorId': 1,
        'lastMessageTime': Timestamp.now(),
      });
      var newChat = await Firestore.instance
          .document('chats/' + chatName(companionId, CatchMeApp.userUid))
          .get();
      return newChat.reference;
    } else {
      print(chat.documentID);
      return chat.reference;
    }
  }

  String chatName(String str1, String str2) {
    return str1.compareTo(str2) > 0 ? str1 + str2 : str2 + str1;
  }
}
