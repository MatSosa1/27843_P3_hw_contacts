import 'package:hw_contacts/domain/entities/contact.dart';

abstract class ContactRepository {
  Future<void> addContact(Contact c);
  Future<List<Contact>> getAllContacts();
  Stream<List<Contact>> watchContacts();
  Future<void> deleteContact(int id);
}
