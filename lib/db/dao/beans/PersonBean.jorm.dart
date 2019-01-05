// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PersonBean.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _PersonBean implements Bean<Person> {
  final userId = StrField('user_id');
  final photoUrl = StrField('photo_url');
  final name = StrField('name');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        userId.name: userId,
        photoUrl.name: photoUrl,
        name.name: name,
      };
  Person fromMap(Map map) {
    Person model = Person();
    model.userId = adapter.parseValue(map['user_id']);
    model.photoUrl = adapter.parseValue(map['photo_url']);
    model.name = adapter.parseValue(map['name']);

    return model;
  }

  List<SetColumn> toSetColumns(Person model,
      {bool update = false, Set<String> only, bool onlyNonNull: false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(userId.set(model.userId));
      ret.add(photoUrl.set(model.photoUrl));
      ret.add(name.set(model.name));
    } else if (only != null) {
      if (only.contains(userId.name)) ret.add(userId.set(model.userId));
      if (only.contains(photoUrl.name)) ret.add(photoUrl.set(model.photoUrl));
      if (only.contains(name.name)) ret.add(name.set(model.name));
    } else /* if (onlyNonNull) */ {
      if (model.userId != null) {
        ret.add(userId.set(model.userId));
      }
      if (model.photoUrl != null) {
        ret.add(photoUrl.set(model.photoUrl));
      }
      if (model.name != null) {
        ret.add(name.set(model.name));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists: false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addStr(userId.name, primary: true, isNullable: false);
    st.addStr(photoUrl.name, isNullable: false);
    st.addStr(name.name, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Person model,
      {bool cascade: false, bool onlyNonNull: false, Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<Person> models,
      {bool onlyNonNull: false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(Person model,
      {bool cascade: false, Set<String> only, bool onlyNonNull: false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<Person> models,
      {bool onlyNonNull: false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<int> update(Person model,
      {bool cascade: false,
      bool associate: false,
      Set<String> only,
      bool onlyNonNull: false}) async {
    final Update update = updater
        .where(this.userId.eq(model.userId))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.update(update);
  }

  Future<void> updateMany(List<Person> models,
      {bool onlyNonNull: false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      where.add(this.userId.eq(model.userId));
    }
    final UpdateMany update = updaters.addAll(data, where);
    await adapter.updateMany(update);
    return;
  }

  Future<Person> find(String userId,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.userId.eq(userId));
    return await findOne(find);
  }

  Future<int> remove(String userId) async {
    final Remove remove = remover.where(this.userId.eq(userId));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Person> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.userId.eq(model.userId));
    }
    return adapter.remove(remove);
  }
}
