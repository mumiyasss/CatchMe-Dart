import 'dart:async';
import 'dart:io';

import 'package:catch_me/models/Person.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:synchronized/synchronized.dart';
import 'package:sqflite/sqflite.dart';

abstract class Db {
    static final dbName = "catchme.db";
    static final _databaseAccessLock = Lock();
    static Database _db;

    Db._();

    static Future<Database> get instance async {
        // Preventing race condition
        if (_db == null) {
            await _databaseAccessLock.synchronized(() async {
                var databasesPath = await getDatabasesPath();
                // Make sure the directory exists
                await Directory(databasesPath).create(recursive: true);
                final path = join(databasesPath, dbName);
                _db = await openDatabase(path);
            });
        }
        return _db;
    }
}

