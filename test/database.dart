import 'package:catch_me/db/Database.dart';
import 'package:catch_me/models/Person.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
    group('Database', () {
        DBProvider database;
        Person person;

        setUpAll(() async {
            database = await DBProvider.instance;
            person = Person()
                ..userId = "123"
                ..name = "Dima"
                ..photoUrl = "http://vk.com";
        });

        test("Creating database", () async {
            expect(true, database.dbExists());
        });
        test("Writing Person", () async {
            database.insertPerson(person);
            var result = await database.getPerson("123");
            expect(person, result);
        });
    });
}