import 'package:hw_contacts/domain/entities/contact.dart';
import 'package:hw_contacts/domain/repositories/contact_repository.dart';

class GetContactsUsecase {
  final ContactRepository repo;

  GetContactsUsecase(this.repo);

  Future<List<Contact>> call() {
    return repo.getAllContacts();
  }
}
