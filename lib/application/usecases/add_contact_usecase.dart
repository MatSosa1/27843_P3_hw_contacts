import 'package:hw_contacts/domain/entities/contact.dart';
import 'package:hw_contacts/domain/repositories/contact_repository.dart';

class AddSong {
  final ContactRepository repo;

  AddSong(this.repo);

  Future<void> call(Contact c) {
    return repo.addContact(c);
  }
}
