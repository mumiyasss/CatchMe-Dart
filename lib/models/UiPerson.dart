import 'package:catch_me/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  String photoUrl;
  String name;
  String userId;
  DocumentReference reference;

  Person.fromSnapshot(DocumentSnapshot userSnapshot) {
    photoUrl = userSnapshot.data['photo'];
    name = userSnapshot.data['name'];
    userId = userSnapshot.data['id'];
    reference = userSnapshot.reference;
  }

  static Future<Person> fromUserId(String userId) async {
    var user =
        await Firestore.instance.collection('users').document(userId).get();
    return Person.fromSnapshot(user);
  }

  static Future<Person> fromPrivateChatMembers(List members) async {
    for (var memberId in members) {
      if (memberId != CatchMeApp.userUid) {
        return await Person.fromUserId(memberId);
      }
    }
    return await Person.fromUserId(CatchMeApp.userUid);
  }
}
