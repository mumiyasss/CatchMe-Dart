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

    static Batch _batch;

    Db._();

    // TODO: check working
    static Future<Database> get instance async {
        // Preventing race condition
        if (_db == null) {
            await _databaseAccessLock.synchronized(() async {
                var databasesPath = await getDatabasesPath();
                // Make sure the directory exists
                await Directory(databasesPath).create(recursive: true);
                final path = join(databasesPath, dbName);
                _db = await openDatabase(path);
                Db._startCommitBatches(5);
            });
        }
        return _db;
    }

    // TODO: нужно ли делать batch, если кэш и так все скидывает рационально?
    // TODO: write with Isolates
    /// Начинает комитить данные в базу данных,
    /// постепенно увеличивая время обновления данных каждый раз
    /// на 5 секунд для экономии батареи.
    static _startCommitBatches(int seconds) async {
        if (_batch != null) _batch.commit();
        _batch = _db.batch();
        await Future.delayed(Duration(seconds: seconds)).then((_) {
            print("BATCH COMMITED");
            _startCommitBatches(seconds + 5);
        }
        );
    }

    // TODO: вызвать onAppClosed
    static onAppClose() {
        _batch?.commit();
    }

    static Batch get batch => _batch;
}

