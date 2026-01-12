import 'package:hw_contacts/data/db/app_db.dart';
import 'package:hw_contacts/domain/entities/contact.dart';

class ContactMapper {
  static Contact toDomain(ContactRow row) => Contact(
      id: row.id,
      name: row.name,
      phone: row.phone,
      email: row.email,
      isFavorite: row.isFavorite
    );

static ContactsTableCompanion toCompanion(Contact c) =>
    ContactsTableCompanion.insert(
      name: c.name,
      phone: c.phone,
      email: c.email,
      isFavorite: c.isFavorite
    );
}
