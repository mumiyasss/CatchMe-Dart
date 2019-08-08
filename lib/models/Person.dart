import 'package:catch_me/main.dart';
import 'package:catch_me/models/Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final String photoUrlColumn = 'photoUrl';
final String nameColumn = 'name';
final String userIdColumn = 'userId';

class Person extends Model {
    String photoUrl;
    String name;
    String userId;
    Timestamp lastSeen;

    Person();

    Person.fromSnapshot(DocumentSnapshot userSnapshot) {
        photoUrl = userSnapshot.data['photo'];
        name = userSnapshot.data['name'];
        userId = userSnapshot.data['id'];
        assert(photoUrl != null);
        assert(name != null);
        assert(userId != null);
    }

    Map<String, dynamic> toMap() {
        var map = <String, dynamic>{
            photoUrlColumn: photoUrl,
            nameColumn: name,
            userIdColumn: userId
        };
        return map;
    }

    Person.fromMap(Map<String, dynamic> map) {
        photoUrl = map[photoUrlColumn];
        name = map[nameColumn];
        userId = map[userIdColumn];
        assert(photoUrl != null);
        assert(name != null);
        assert(userId != null);
    }

    @override
    String toString() {
        return 'Person{photoUrl: $photoUrl, name: $name, userId: $userId, lastSeen: $lastSeen}';
    }

    @override
    dynamic get pk => userId;
}
