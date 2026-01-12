import 'package:drift/drift.dart';

@DataClassName('ContactRow')
class ContactsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phone => text()();
  TextColumn get email => text()();
  BoolColumn get isFavorite => boolean()();
}
