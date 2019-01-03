import 'package:catch_me/models/UiPerson.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessageViewModel {
  Stream<QuerySnapshot> get _usersCollection => Firestore.instance
      .collection('users')
      .snapshots();

  Stream<List<UiPerson>> get users async* {
    await for (var users in _usersCollection) {
      yield users.documents
          .map((userSnapshot) => UiPerson.fromSnapshot(userSnapshot))
          .toList();
    }
  }
}