import 'dart:io';

import 'package:catch_me/models/Person.dart';
import 'package:path/path.dart';
import 'package:synchronized/synchronized.dart';
import 'package:sqflite/sqflite.dart';

final String personTable = "person_table";

class DBProvider {
    static final dbName = "catchme.db";
    static final _databaseAccessLock = Lock();
    static Database _db;

    DBProvider._();

    // TODO: check working
    static Future<DBProvider> get instance async {
        // Preventing race condition
        await _databaseAccessLock.synchronized(() async {
            if (_db == null) {
                var databasesPath = await getDatabasesPath();
                // Make sure the directory exists
                await Directory(databasesPath).create(recursive: true);
                final path = join(databasesPath, dbName);
                _db = await openDatabase(path, version: 1,
                    onCreate: (Database db, int version) async {
                        await db.execute(
                            '''CREATE TABLE $personTable (
                            $userIdColumn text primary key,
                            $nameColumn text not null,
                            $photoUrlColumn text)
                            ''');
                    }
                );
            }
        });
        return DBProvider._();
    }

    bool dbExists() => _db != null;

    insertPerson(Person person) async {
        await _db.insert(personTable, person.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
    }

    updatePerson(Person person) async {
        await _db.update(personTable, person.toMap(),
            where: '$userIdColumn = ?',
            whereArgs: [person.userId]);
    }

    Future<Person> getPerson(String userId) async {
        List<Map> maps = await _db.query(personTable,
            columns: null,
            where: "$userIdColumn = ?",
            whereArgs: [userId]
        );
        return Person.fromMap(maps.first);
    }
}

