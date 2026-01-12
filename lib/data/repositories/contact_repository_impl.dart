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
}
