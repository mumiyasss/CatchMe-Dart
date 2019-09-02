import 'package:catch_me/dao/cached_db/db/db.dart';
import 'package:catch_me/dao/cached_db/db/exceptions.dart';
import 'package:catch_me/models/Person.dart';
import 'package:catch_me/repository/repository.dart';
import 'package:sqflite/sqflite.dart';

final String personTable = "personTable";

class PersonHelper extends Repository<Person> {
    PersonHelper._();

    static PersonHelper _dao;
    static Database _db;

    static Future<PersonHelper> get instance async {
        if (_dao == null) {
            _db = await Db.instance
                ..execute('''CREATE TABLE IF NOT EXISTS $personTable (
                            $userIdColumn text primary key,
                            $nameColumn text not null,
                            $photoUrlColumn text,
                            $emailColumn text)
                            ''');
            _dao = PersonHelper._();
        }
        return _dao;
    }

    @override
    insert(Person person) {
        _db.insert(personTable, person.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
    }

    @override
    update(Person person) {
        _db.update(personTable, person.toMap(),
            where: '$userIdColumn = ?',
            whereArgs: [person.userId]);
    }

    // TODO: pageNumber implementation
    @override
    Future<List<Person>> getAll({pageNumber = 0}) async {
        List<Map> maps = await _db.query(personTable,
            columns: null
        );
        return maps.map((personMap) => Person.fromMap(personMap)).toList();
    }

    @override
    insertAll(List<Person> objects) {
        objects.forEach((person) => insert(person));
    }

    @override
    Future<Person> get(String userId) async {
        List<Map> maps = await _db.query(personTable,
            columns: null,
            where: "$userIdColumn = ?",
            whereArgs: [userId],
            limit: 1
        );
        try {
            return Person.fromMap(maps.first);
        } on StateError {
            throw NotFound();
        }
    }

    @override
    delete(Person obj) {
        throw Exception('Not implemented delete method for Person()');
    }

    @override
    deleteAll() {
        _db.delete(personTable);
    }
}
