import 'package:drift/drift.dart';
import 'package:hw_contacts/data/db/app_db.dart';
import 'package:hw_contacts/data/mappers/contact_mapper.dart';
import 'package:hw_contacts/domain/entities/contact.dart';
import 'package:hw_contacts/domain/repositories/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final AppDatabase db;

  ContactRepositoryImpl(this.db);

  @override
  Future<void> addContact(Contact c) async {
    await db.into(db.contactsTable)
      .insert(ContactMapper.toCompanion(c));
  }

  @override
  Future<List<Contact>> getAllContacts() async {
    final rows = await db.select(db.contactsTable).get();
    return rows.map(ContactMapper.toDomain).toList();
  }

  @override
  Stream<List<Contact>> watchFavoriteContacts() {
    return (db.select(db.contactsTable)
        ..where((c) => c.isFavorite.equals(true)))
      .watch()
      .map(
        (rows) => rows.map(ContactMapper.toDomain).toList(),
      );
  }

  @override
  Stream<List<Contact>> watchContacts() {
    return db.select(db.contactsTable)
      .watch()
      .map((rows) => rows.map(ContactMapper.toDomain).toList());
  }

  @override
  Future<void> deleteContact(int id) async {
    await (db.delete(db.contactsTable)
        ..where((tbl) => tbl.id.equals(id)))
      .go();
  }

  @override
  Future<void> toggleFavorite(int contactId) async {
    final query = db.update(db.contactsTable)
      ..where((c) => c.id.equals(contactId));

    await query.write(
      ContactsTableCompanion(
        isFavorite: Value(
          !(await _isFavorite(contactId)),
        ),
      ),
    );
  }

  Future<bool> _isFavorite(int contactId) async {
    final row = await (db.select(db.contactsTable)
          ..where((c) => c.id.equals(contactId)))
        .getSingle();

    return row.isFavorite;
  }
}
