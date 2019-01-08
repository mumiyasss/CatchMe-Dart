import 'dart:collection';

import 'package:catch_me/db/Db.dart';
import 'package:catch_me/db/dao/beans/PersonBean.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/src/exception.dart';

class PersonDao {
  static final cachedPeople = Map<String, Person>();

  static Stream<Person> fromPrivateChatCompanion(List members) async* {
    var companionId = _getCompanionId(members);
    final personBean = await PersonBean.get();
    var cachedPerson = cachedPeople[companionId];
    var person = cachedPerson != null
        ? cachedPerson
        : await personBean.find(companionId);
    if (person != null) {
      yield person;
      cachedPeople[companionId] = person; 
    }
    var userSnapshots = Firestore.instance
        .collection('users')
        .document(companionId)
        .snapshots();
    await for (var user in userSnapshots) {
      var newUser = _fromSnapshot(user);
      yield newUser;
      person == null ? personBean.insert(newUser) : personBean.update(newUser);
      cachedPeople[companionId] = newUser;
    }
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
