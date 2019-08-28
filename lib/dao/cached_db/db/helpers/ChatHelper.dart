import 'package:catch_me/dao/cached_db/db/db.dart';
import 'package:catch_me/dao/cached_db/db/helpers/PersonHelper.dart';
import 'package:catch_me/models/Chat.dart';
import 'package:catch_me/models/Person.dart';
import 'package:catch_me/repository/repository.dart';
import 'package:catch_me/values/constants.dart';
import 'package:sqflite/sqflite.dart';

final String chatTable = "chatTable";

class ChatHelper extends Repository<Chat> {
    ChatHelper._();
    static ChatHelper _dao;
    static Database _db;

    static Future<ChatHelper> get instance async {
        if (_dao == null) {
            _db = await Db.instance;
            await PersonHelper.instance; // Create PersonTable if not exists for FK
            await _db.execute('''CREATE TABLE IF NOT EXISTS $chatTable (
                            $chatPathColumn text primary key,
                            $timeColumn text not null,
                            $unreadColumn integer,
                            $lastMessageColumn text not null,
                            $companionIdColumn text not null,
                            FOREIGN KEY ($companionIdColumn) 
                                REFERENCES $personTable($userIdColumn)
                            )
                            ''');
            _dao = ChatHelper._();
        }
        return _dao;
    }

    delete(Chat chat) {
        _db.delete(chatTable,
            where: '$chatPathColumn = ?',
            whereArgs: [chat.reference.path]
        );
    }

    insert(Chat chat) {
         _db.insert(chatTable, chat.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
    }

    insertAll(List<Chat> chats) {
        chats.forEach((chat) => insert(chat));
    }

    update(Chat chat) {
        _db.update(chatTable, chat.toMap(),
            where: '$chatPathColumn = ?',
            whereArgs: [chat.reference.path]);
    }

    deleteAll() {
        _db.rawQuery("DELETE FROM $chatTable");
    }


    /// Возвращает все объекты. Если передан параметр pageNumber,
    /// возвращаются последние 50 объектов.
    /// Например:
    ///     pageNumber = 1 - последние 50 объектов.
    ///     pageNumber = 2 - последние 51-100 объектов, и т.д.
    Future<List<Chat>> getAll({int pageNumber = 0}) async {
        List<Map> maps = await _db.query(chatTable,
            columns: null,
            orderBy: timeColumn,
            limit: pageNumber > 0 ? OBJECTS_PER_PAGE : null,
            offset: pageNumber > 0 ? --pageNumber * OBJECTS_PER_PAGE : null
        );
        var chatList = List<Chat>();
        for (var map in maps) {
            chatList.add(await Chat.fromMap(map));
        }
        return chatList;
    }

    Future<Chat> get(String chatPath) async {
        List<Map> maps = await _db.query(chatTable,
            columns: null,
            where: "$chatPathColumn = ?",
            whereArgs: [chatPath],
            limit: 1
        );
        return Chat.fromMap(maps.first);
    }
}