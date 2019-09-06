import 'package:catch_me/models/Model.dart';

abstract class Repository<T extends Model> {
    insert(T obj);

    update(T obj);

    Future delete(T obj);

    Future deleteAll();

    /// Возвращает все объекты. Если передан параметр pageNumber,
    /// возвращаются последние 50 объектов.
    /// Например:
    ///     pageNumber = 1 - последние 50 объектов.
    ///     pageNumber = 2 - последние 51-100 объектов, и т.д.
    Future<List<T>> getAll({int pageNumber});

    Future<T> get(String pk);

    insertAll(List<T> objects);
}