// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CarBean.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _CarBean implements Bean<Car> {
  final id = IntField('id');
  final name = StrField('name');
  final brand = StrField('brand');
  final carModel = StrField('car_model');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
        brand.name: brand,
        carModel.name: carModel,
      };
  Car fromMap(Map map) {
    Car model = Car();
    model.id = adapter.parseValue(map['id']);
    model.name = adapter.parseValue(map['name']);
    model.brand = adapter.parseValue(map['brand']);
    model.carModel = adapter.parseValue(map['car_model']);

    return model;
  }

  List<SetColumn> toSetColumns(Car model,
      {bool update = false, Set<String> only, bool onlyNonNull: false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      ret.add(name.set(model.name));
      ret.add(brand.set(model.brand));
      ret.add(carModel.set(model.carModel));
    } else if (only != null) {
      if (model.id != null) {
        if (only.contains(id.name)) ret.add(id.set(model.id));
      }
      if (only.contains(name.name)) ret.add(name.set(model.name));
      if (only.contains(brand.name)) ret.add(brand.set(model.brand));
      if (only.contains(carModel.name)) ret.add(carModel.set(model.carModel));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.name != null) {
        ret.add(name.set(model.name));
      }
      if (model.brand != null) {
        ret.add(brand.set(model.brand));
      }
      if (model.carModel != null) {
        ret.add(carModel.set(model.carModel));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists: false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, autoIncrement: true, isNullable: false);
    st.addStr(name.name, isNullable: false);
    st.addStr(brand.name, isNullable: false);
    st.addStr(carModel.name, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Car model,
      {bool cascade: false, bool onlyNonNull: false, Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .id(id.name);
    var retId = await adapter.insert(insert);
    if (cascade) {
      Car newModel;
    }
    return retId;
  }

  Future<void> insertMany(List<Car> models,
      {bool onlyNonNull: false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(Car model,
      {bool cascade: false, Set<String> only, bool onlyNonNull: false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .id(id.name);
    var retId = await adapter.upsert(upsert);
    if (cascade) {
      Car newModel;
    }
    return retId;
  }

  Future<void> upsertMany(List<Car> models,
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

  Future<int> update(Car model,
      {bool cascade: false,
      bool associate: false,
      Set<String> only,
      bool onlyNonNull: false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.update(update);
  }

  Future<void> updateMany(List<Car> models,
      {bool onlyNonNull: false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      where.add(this.id.eq(model.id));
    }
    final UpdateMany update = updaters.addAll(data, where);
    await adapter.updateMany(update);
    return;
  }

  Future<Car> find(int id, {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(int id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Car> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }
}
