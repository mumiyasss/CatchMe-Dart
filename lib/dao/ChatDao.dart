import 'package:catch_me/dao/PersonDao.dart';
import 'package:catch_me/dao/cached_db/store.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Chat.dart';
import 'package:catch_me/models/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
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
    });

    ChatDao._() {
        _chatCollectionFromNet.listen((data) {
            _chatsStore.insertAll(data);
        });
    }

    String _chatName(String str1, String str2) {
        assert(str1 != null && str2 != null);
        return str1.compareTo(str2) > 0 ? str1 + str2 : str2 + str1;
    }

    deleteChat(Chat chat) async {
        chat.reference.delete();
        _chatsStore.delete(chat);
        final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
            functionName: 'deleteChat',
        );
        dynamic resp = await callable.call(<String, dynamic>{
            'chatPath': chat.pk,
        });
        print("response for chat delete $resp ");
    }

    // Может быть сделать стрим кэша?
    Observable<List<Chat>> getAll() =>
        Observable
            .just(_chatsStore.getAll())
            .mergeWith([_chatCollectionFromNet]);

    /// Requires internet connection
    Chat getChatWithPerson(String personId) {
        var chatName = _chatName(personId, CatchMeApp.userUid);
        return _chatsStore.get('chats/' + chatName);
    }

    Stream<DocumentSnapshot> getChatWithPersonFromInet(String personId){
        var chatName = _chatName(personId, CatchMeApp.userUid);

        var chat = Firestore.instance
            .document('chats/' + chatName)
            .snapshots();
        return chat;
    }

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