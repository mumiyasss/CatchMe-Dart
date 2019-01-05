import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class Db {
  static SqfliteAdapter _adapter;
  
  static Future<SqfliteAdapter> getAdapter() async {
    if (_adapter == null)
      Future.delayed(Duration(milliseconds: 20)).then((_) => getAdapter());
    return _adapter;
  }

  static void init() async {
    if (_adapter == null) {
      var dbPath = await getDatabasesPath();
      var adapter = SqfliteAdapter(path.join(dbPath, "orm.db"));
      await adapter.connect();
      _adapter = adapter;
    }
  }
}
