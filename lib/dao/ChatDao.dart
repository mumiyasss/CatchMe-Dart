import 'package:catch_me/dao/PersonDao.dart';
import 'package:catch_me/dao/cached_db/store.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ChatDao {

    static ChatDao _instance;
    static ChatStore _chatsStore;

    static Future<ChatDao> get instance async {
        if (_instance == null) {
            _chatsStore = await ChatStore.instance;
            _instance = ChatDao._();
        }
        return _instance;
    }

    final Observable<List<Chat>> _chatCollectionFromNet = Observable(
        Firestore.instance
            .collection('chats')
            .where('members', arrayContains: CatchMeApp.userUid)
            .orderBy(
            'lastMessageTime', descending: true) // ? Query requires Index.
            .snapshots())
        .asyncMap((chatDoc) async {
        var chats = List<Chat>();
        for (var chatSnapshot in chatDoc.documents) {
            chats.add(await ChatDao.fromSnapshot(chatSnapshot));
        }
        _chatsStore.insertAll(chats);
        return chats;
    });

    ChatDao._();

    // Может быть сделать стрим кэша?
    Observable<List<Chat>> getAll() =>
        Observable
            .fromFuture(_chatsStore.getAll())
            .mergeWith([_chatCollectionFromNet]);

    Future<Chat> getChatInfo(DocumentReference chatReference) async {
        return await _chatsStore.get(chatReference.path);
    }

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

        chat.companion = await
        (await PersonDao.instance)
            .fromPrivateChatMembers(chatSnapshot.data['members'])
            .first;

        assert(chat.companion != null);
        return chat;
    }
}