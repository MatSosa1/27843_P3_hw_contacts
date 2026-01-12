import 'package:hw_contacts/domain/repositories/contact_repository.dart';

class ToggleFavoriteContactUsecase {
  final ContactRepository repo;

  ToggleFavoriteContactUsecase(this.repo);

  Future<void> call(int contactId) {
    return repo.toggleFavorite(contactId);
  }
}