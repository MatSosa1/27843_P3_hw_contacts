import 'package:hw_contacts/domain/entities/contact.dart';
import 'package:hw_contacts/domain/repositories/contact_repository.dart';

class WatchFavoriteContactsUsecase {
  final ContactRepository repo;

  WatchFavoriteContactsUsecase(this.repo);

  Stream<List<Contact>> call() {
    return repo.watchFavoriteContacts();
  }
}
