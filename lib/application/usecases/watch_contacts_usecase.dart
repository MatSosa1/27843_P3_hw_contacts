import 'package:hw_contacts/domain/entities/contact.dart';
import 'package:hw_contacts/domain/repositories/contact_repository.dart';

class WatchContactsUsecase {
  final ContactRepository repo;

  WatchContactsUsecase(this.repo);

  Stream<List<Contact>> call() {
    return repo.watchContacts();
  }
}
