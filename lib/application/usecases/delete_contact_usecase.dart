import 'package:hw_contacts/domain/repositories/contact_repository.dart';

class DeleteContactUsecase {
  final ContactRepository repo;

  DeleteContactUsecase(this.repo);

  Future<void> call(int id) {
    return repo.deleteContact(id);
  }
}
