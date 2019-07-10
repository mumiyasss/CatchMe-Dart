import 'package:catch_me/models/Chat.dart';
import 'package:catch_me/models/Message.dart';
import 'package:catch_me/models/Model.dart';
import 'package:catch_me/models/Person.dart';
import 'package:catch_me/repository/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

abstract class CachedDb<T extends Model> implements Repository<T> {

    Repository<T> dbHelper;
    Map<dynamic, T> cachedData = Map<dynamic, T>();

    CachedDb(this.dbHelper) {
        startDelayedDbUpdating(seconds: 5);
    }

    @protected
    cacheOnStartApp({int pageNumber = 0}) async {
        if (pageNumber == 0) {
            (await dbHelper.getAll(pageNumber: pageNumber))
                .forEach((obj) {
                cachedData[obj.pk] = obj;
            });
        }
    }

    /// Каждые несколько секунд обновляет данные из базы данных.
    @protected
    startDelayedDbUpdating({@required int seconds}) async {
        Future.delayed(Duration(seconds: seconds)).then((_) {
            cachedData?.forEach((_, obj) => dbHelper.insert(obj));
            startDelayedDbUpdating(seconds: seconds);
        });
    }
}