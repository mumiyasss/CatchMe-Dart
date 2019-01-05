import 'package:catch_me/db/Db.dart';
import 'package:catch_me/db/dao/beans/PersonBean.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonDao {
  static Stream<Person> fromPrivateChatCompanion(List members) async* {
    var companionId = _getCompanionId(members);
    final personBean = PersonBean(await Db.getAdapter());
    await personBean.createTable();
    // Дальше todo
    var user = await Firestore.instance
        .collection('users')
        .document(companionId)
        .get();
    var person = _fromSnapshot(user);
    
    yield person;
  }

  static Person _fromSnapshot(DocumentSnapshot userSnapshot) {
    return Person()
      ..photoUrl = userSnapshot.data['photo']
      ..name = userSnapshot.data['name']
      ..userId = userSnapshot.data['id'];
  }

  static String _getCompanionId(List members) {
    for (var memberId in members)
      if (memberId != CatchMeApp.userUid) {
        return memberId;
      }
    throw Exception('NO COMPANION ID FOUND!');
  }
}
