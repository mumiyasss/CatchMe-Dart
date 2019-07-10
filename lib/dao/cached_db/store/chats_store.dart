import 'package:catch_me/dao/cached_db/cached_db.dart';
import 'package:catch_me/dao/cached_db/db/helpers/ChatHelper.dart';
import 'package:catch_me/models/Chat.dart';
import 'package:catch_me/repository/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


// Постоянно актуальный кэш должен скидывать все свои данные
// в базу данных. Таким образом база данных будет постоянно
// актуальной, не будет ненужных операций.
class ChatsStore extends CachedDb<Chat> {

    static ChatsStore _instance;
    static Future<ChatsStore> get instance async {
        if (_instance == null) {
            _instance = ChatsStore._(await ChatHelper.instance);
            await _instance.cacheOnStartApp(pageNumber: 0);
        }
        return _instance;
    }
    ChatsStore._(Repository<Chat> helper) : super(helper);

    /// Возвращает все объекты. Если передан параметр pageNumber,
    /// возвращаются последние 50 объектов.
    /// Например:
    ///     pageNumber = 1 - последние 50 объектов.
    ///     pageNumber = 2 - последние 51-100 объектов, и т.д.
    @override
    Future<List<Chat>> getAll({int pageNumber = 0}) async {
        var chats = List<Chat>();
        cachedData?.forEach((_, chat) => chats.add(chat));
        return chats;
    }

    // what to do?
    @override
    Future<Chat> get(String chatReferencePath) async {
        return cachedData[chatReferencePath];
    }

    @override
    insertAll(List<Chat> chats) {
        chats.forEach((chat) => insert(chat));
    }

    @override
    insert(Chat chat) {
        assert(chat != null);
        cachedData[chat.reference.path] = chat;
    }

    @override
    deleteAll() {
        cachedData.clear();
    }

    @override
    update(Chat chat) {
        cachedData[chat.reference.path] = chat;
    }
}