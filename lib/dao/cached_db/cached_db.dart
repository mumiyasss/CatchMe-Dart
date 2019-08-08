import 'package:catch_me/dao/cached_db/db/helpers/PersonHelper.dart';
import 'package:catch_me/models/Chat.dart';
import 'package:catch_me/models/Message.dart';
import 'package:catch_me/models/Model.dart';
import 'package:catch_me/models/Person.dart';
import 'package:catch_me/repository/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';


/// Родительский класс для всех классов типа Store.
///
/// Постоянно актуальный кэш регулярно скидывает все свои данные
/// в базу данных. Таким образом база данных будет постоянно
/// актуальной, не будет ненужных операций.
class CachedDb<T extends Model> implements Repository<T> {

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

    /// Один раз немедля обновить базу данных.
    updateDbRightNow() async {
        cachedData?.forEach((_, obj) => dbHelper.insert(obj));
    }
    

    /// Возвращает все объекты. Если передан параметр pageNumber,
    /// возвращаются последние 50 объектов.
    /// Например:
    ///     pageNumber = 1 - последние 50 объектов.
    ///     pageNumber = 2 - последние 51-100 объектов, и т.д.
    @override
    Future<List<T>> getAll({int pageNumber = 0}) async {
        var objects = List<T>();
        cachedData?.forEach((_, obj) => objects.add(obj));
        return objects;
    }

    @override
    Future<T> get(String pk) async {
        return cachedData[pk];
    }

    @override
    insertAll(List<T> objects) {
        objects.forEach((obj) => insert(obj));
    }

    @override
    insert(T obj) {
        assert(obj != null);
        cachedData[obj.pk] = obj;
    }

    @override
    deleteAll() {
        cachedData.clear();
    }

    @override
    update(T obj) {
        cachedData[obj.pk] = obj;
    }
}