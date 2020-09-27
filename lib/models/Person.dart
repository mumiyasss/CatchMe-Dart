import 'package:catch_me/main.dart';
import 'package:catch_me/models/Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final String photoUrlColumn = 'photoUrl';
final String nameColumn = 'name';
final String userIdColumn = 'userId';
final String emailColumn = 'email';
final String lastSeenColumn = 'lastSeen';
final String phoneColumn = 'phone';

class Person extends Model {
    String photoUrl;
    String name;
    String userId;
    String email; // todo: not saving to database
    int lastSeen; // in milliseconds

    Person();

    Person.fromSnapshot(DocumentSnapshot userSnapshot) {

        photoUrl = userSnapshot.data()[photoUrlColumn];
        name = userSnapshot.data()[nameColumn];
        userId = userSnapshot.data()[userIdColumn];
        email = userSnapshot.data()[emailColumn];
        lastSeen = userSnapshot.data()[lastSeenColumn];
        assert(name != null);
        assert(userId != null);
    }

    Person.fromFirebaseUserInfo(UserInfo info) {
        photoUrl = info.photoURL;
        name = info.displayName;
        userId = info.uid;
        email = info.email;
    }

    Map<String, dynamic> toMap() {
        var map = <String, dynamic>{
            photoUrlColumn: photoUrl,
            nameColumn: name,
            userIdColumn: userId,
            emailColumn: email,
            lastSeenColumn: lastSeen,
        };
        return map;
    }

    Person.fromMap(Map<String, dynamic> map) {
        photoUrl = map[photoUrlColumn];
        name = map[nameColumn];
        userId = map[userIdColumn];
        email = map[emailColumn];
        lastSeen = map[lastSeenColumn];
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
