import 'package:catch_me/dao/cached_db/cached_db.dart';
import 'package:catch_me/dao/cached_db/db/helpers/ChatHelper.dart';
import 'package:catch_me/dao/cached_db/db/helpers/PersonHelper.dart';
import 'package:catch_me/models/Chat.dart';
import 'package:catch_me/models/Model.dart';
import 'package:catch_me/models/Person.dart';
import 'package:catch_me/repository/repository.dart';

/// Person store.
class PersonStore extends CachedDb<Person> {
    static PersonStore _instance;

    static Future<PersonStore> get instance async {
        if (_instance == null) {
            _instance = PersonStore._(await PersonHelper.instance);
            await _instance.cacheOnStartApp();
        }
        return _instance;
    }

    PersonStore._(Repository<Person> helper) : super(helper);
}

/// Person store.
class ChatStore extends CachedDb<Chat> {
    static ChatStore _instance;

    static Future<ChatStore> get instance async {
        if (_instance == null) {
            _instance = ChatStore._(await ChatHelper.instance);
            await _instance.cacheOnStartApp();
        }
        return _instance;
    }

    ChatStore._(Repository<Chat> helper) : super(helper);
}