import 'package:catch_me/dao/PersonDao.dart';
import 'package:catch_me/dao/cached_db/db/helpers/PersonHelper.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Model.dart';
import 'package:catch_me/models/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Todo: подвязать к Person ???
final String companionIdColumn = "companionColumn";
final String lastMessageColumn = "lastMessageColumn";
final String timeColumn = "lastSeenColumn";
final String unreadColumn = "unreadColumn";
final String chatPathColumn = "documentPathColumn";

class Chat extends Model {

    Person companion;
    String message;
    String time;
    int unread;
    DocumentReference reference;

    @override
    dynamic get pk => reference.path;

    // Todo in Dart 2.5 => to expended methods
    Map<String, dynamic> toMap() {
        if(companion == null) {
            print(companion);
        }
        assert(companion != null);
        assert(reference.path != null);
        return <String, dynamic>{
            companionIdColumn: companion.userId,
            lastMessageColumn: message,
            timeColumn: time,
            unreadColumn: unread,
            chatPathColumn: reference.path
        };
    }

    static Future<Chat> fromSnapshot(DocumentSnapshot snapshot) async {
        var data = snapshot.data;
        return Chat()
            ..companion = await (await PersonDao.instance)
                .fromPrivateChatMembers(data['members']).first
            ..message = data['lastMessageText']
            ..unread = data['unread']
            ..time = data['lastMessageTime']
            ..reference = snapshot.reference;
    }

    // Todo in Dart 2.5 => to expended methods
    static Future<Chat> fromMap(Map<String, dynamic> map) async {
        assert(map[companionIdColumn] != null);
        return Chat()
            ..companion = await (await PersonDao.instance)
                .fromUserId(map[companionIdColumn])
                .first
            ..message = map[lastMessageColumn]
            ..unread = map[unreadColumn]
            ..time = map[timeColumn]
            ..reference = Firestore.instance
                .document(map[chatPathColumn]);
    }
}
