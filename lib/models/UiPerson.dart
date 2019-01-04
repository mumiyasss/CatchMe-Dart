import 'package:catch_me/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UiPerson {
  String photoUrl;
  String name;
  String userId;
  DocumentReference reference;

  UiPerson.fromSnapshot(DocumentSnapshot userSnapshot) {
    photoUrl = userSnapshot.data['photo'];
    name = userSnapshot.data['name'];
    userId = userSnapshot.data['id'];
    reference = userSnapshot.reference;
  }

  static Future<UiPerson> fromUserId(String userId) async {
    var user =
        await Firestore.instance.collection('users').document(userId).get();
    return UiPerson.fromSnapshot(user);
  }

  static Future<UiPerson> fromPrivateChatMembers(List members) async {
    for (var memberId in members) {
      if (memberId != CatchMeApp.userUid) {
        return await UiPerson.fromUserId(memberId);
      }
    }
    return await UiPerson.fromUserId(CatchMeApp.userUid);
  }
}
