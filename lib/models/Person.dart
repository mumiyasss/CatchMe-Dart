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
    }

    static Future<Person> fromUserId(String userId) async {
        var user = await Firestore
            .instance
            .collection('users')
            .document(userId)
            .get();
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
    }

    @override
    String toString() {
        return 'Person{photoUrl: $photoUrl, name: $name, userId: $userId, lastSeen: $lastSeen}';
    }

    @override
    dynamic get pk => userId;
}
