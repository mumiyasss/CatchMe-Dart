import 'package:catch_me/main.dart';
import 'package:catch_me/models/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessageViewModel {
  Stream<QuerySnapshot> get _usersCollection =>
      Firestore.instance.collection('users').snapshots();

  Stream<List<Person>> get users async* {
    await for (var users in _usersCollection) {
      yield users.documents
          .map((userSnapshot) => Person.fromSnapshot(userSnapshot))
          .toList();
    }
  }

  Future<DocumentReference> startNewConversation(String companionId) async {
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
        'members': [companionId, CatchMeApp.userUid],
        'lastMessageText':
            (await Person.fromUserId(CatchMeApp.userUid)).name +
                " создал",
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
