import 'package:catch_me/dao/cached_db/db/helpers/PersonHelper.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Model.dart';
import 'package:catch_me/models/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Todo: подвязать к Person ???
final String companionColumn = "companionColumn";
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

    Chat();

    static Future<Chat> fromSnapshot(DocumentSnapshot chatSnapshot) async {
        Chat chat = Chat();
        chat.reference = chatSnapshot.reference;

        var timeStamp = (chatSnapshot.data['lastMessageTime'] as Timestamp);
        chat.time = timeStamp
            .toDate()
            .hour
            .toString() + ':' + timeStamp
            .toDate()
            .minute
            .toString();

        chat.message = chatSnapshot.data['lastMessageText'];
        chat.unread = null;
        chat.companion =
        await Person.fromPrivateChatMembers(chatSnapshot.data['members']);
        return chat;
    }


    // Todo in Dart 2.4 => to expended methods
    Map<String, dynamic> toMap() {
        return <String, dynamic>{
            companionColumn: companion.userId,
            lastMessageColumn: message,
            timeColumn: time,
            unreadColumn: unread,
            chatPathColumn: reference.path
        };
    }

    // Todo in Dart 2.4 => to expended methods
    static Future<Chat> fromMap(Map<String, dynamic> map) async {
        return Chat()
            ..companion = await (await PersonHelper.instance)
                .get(map[userIdColumn])
            ..message = map[lastMessageColumn]
            ..unread = map[unreadColumn]
            ..time = map[timeColumn]
            ..reference = Firestore.instance
                .document(map[chatPathColumn]);
    }
}
