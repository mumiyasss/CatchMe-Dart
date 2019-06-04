
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String text;
  final String author;
  final Timestamp timestamp;
  final DocumentReference reference;

  Message.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['text'] != null),
        assert(map['author'] != null),
        assert(map['timestamp'] != null),
        text = map['text'],
        timestamp = map['timestamp'],
        author = map['author'];

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$text:$author>";
}