import 'package:flutter_test/flutter_test.dart';

import 'database.dart';

// run test with 'flutter run test/database_test.dart'
void main() {
  group('database tests', () {
    TestDatabase database;

    setUpAll(() async {
      database = await TestDatabase.openDatabase();
    });

    tearDown(() async {
      await database.database.execute('DELETE FROM Person');
    });

    test('database initially is empty', () async {
      final actual = await database.findAllPersons();

      expect(actual, isEmpty);
    });

    test('insert person', () async {
      final person = Person(null, 'Simon');
      await database.insertPerson(person);

      final actual = await database.findAllPersons();

      expect(actual, hasLength(1));
    });

    test('delete person', () async {
      final person = Person(1, 'Simon');
      await database.insertPerson(person);

      await database.deletePerson(person);

      final actual = await database.findAllPersons();
      expect(actual, isEmpty);
    });

    test('update person', () async {
      final person = Person(1, 'Simon');
      await database.insertPerson(person);

      final updatedPerson = Person(person.id, 'Frank');
      await database.updatePerson(updatedPerson);

      final actual = await database.findPersonById(person.id);
      expect(actual, updatedPerson);
    });
  });
}
