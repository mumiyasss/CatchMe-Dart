import 'package:catch_me/dao/PersonDao.dart';
import 'package:catch_me/dao/cached_db/store.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:catch_me/dao/cached_db/db/exceptions.dart';


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
        .asyncMap((chatCollection) async {
        var chats = List<Chat>();
        for (var chatSnapshot in chatCollection.documents) {
            chats.add(await Chat.fromSnapshot(chatSnapshot));
        }
        _chatsStore.insertAll(chats);
        return chats;
    }).asBroadcastStream();

    ChatDao._() {
        _chatCollectionFromNet.listen((data) {
            _chatsStore.insertAll(data);
        });
    }


    deleteChat(Chat chat) async {
        chat.reference.delete();
        _chatsStore.delete(chat);
    }

    // Может быть сделать стрим кэша?
    Observable<List<Chat>> getAll() =>
        Observable
            .just(_chatsStore.getAll())
            .mergeWith([_chatCollectionFromNet]);


    Future<Chat> getChatInfo(DocumentReference chatReference) async {
        try {
            return _chatsStore.get(chatReference.path);
        } on NotFound {
            var chat = await Chat.fromSnapshot(await chatReference.get());
            _chatsStore.insert(chat);
            return chat;
        }
    }
}