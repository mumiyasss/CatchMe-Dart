import 'package:catch_me/dao/cached_db/store/chats_store.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ChatDao {

    static ChatDao _instance;
    static ChatsStore _chatsStore;

    static Future<ChatDao> get instance async {
        if (_instance == null) {
            _chatsStore = await ChatsStore.instance;
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
        var list = List<Chat>();
        for (var chatSnapshot in chatDoc.documents) {
            list.add(await Chat.fromSnapshot(chatSnapshot));
        }
        return list;
    });

    ChatDao._() {
        _chatCollectionFromNet.listen((chats) async {
            _chatsStore.insertAll(chats);
        });
    }


    // Может быть сделать стрим кэша?
    Observable<List<Chat>> getAll() =>
        Observable
            .fromFuture(_chatsStore.getAll())
            .mergeWith([_chatCollectionFromNet]);

    Future<Chat> getChatInfo(DocumentReference chatReference) async {
        return await _chatsStore.get(chatReference.path);
    }
}