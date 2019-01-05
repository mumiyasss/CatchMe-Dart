import 'package:catch_me/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

class Person {
  @PrimaryKey()
  String userId;
  String photoUrl;
  String name;

  Person();

  Person.fromSnapshot(DocumentSnapshot userSnapshot) {
    photoUrl = userSnapshot.data['photo'];
    name = userSnapshot.data['name'];
    userId = userSnapshot.data['id'];
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
