
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String text;
  final String author;
  final Timestamp timestamp;
  final DocumentReference reference;
  final String imageUrl;

  Message.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['text'] != null || map['image'] != null),
        assert(map['author'] != null),
        assert(map['timestamp'] != null),
        imageUrl = map['image'],
        text = map['text'],
        timestamp = map['timestamp'],
        author = map['author'];

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<${text ?? imageUrl}:$author>";
}