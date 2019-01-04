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
  
}