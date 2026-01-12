import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hw_contacts/application/usecases/add_contact_usecase.dart';
import 'package:hw_contacts/application/usecases/delete_contact_usecase.dart';
import 'package:hw_contacts/application/usecases/get_contacts_usecase.dart';
import 'package:hw_contacts/application/usecases/watch_contacts_usecase.dart';
import 'package:hw_contacts/data/db/app_db.dart';
import 'package:hw_contacts/data/repositories/contact_repository_impl.dart';
import 'package:hw_contacts/domain/entities/contact.dart';
import 'package:hw_contacts/domain/repositories/contact_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();

  // Cierra la DB cuando nadie la use
  ref.onDispose(() => db.close());

  return db;
});

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ContactRepositoryImpl(db);
});

// UseCases
final watchContactsUseCaseProvider = Provider<WatchContactsUsecase>((ref) {
  final repository = ref.watch(contactRepositoryProvider);
  return WatchContactsUsecase(repository);
});

final addContactUseCaseProvider = Provider<AddContactUsecase>((ref) {
  final repository = ref.watch(contactRepositoryProvider);
  return AddContactUsecase(repository);
});

final getContactUseCaseProvider = Provider<GetContactsUsecase>((ref) {
  final repository = ref.watch(contactRepositoryProvider);
  return GetContactsUsecase(repository);
});

final deleteContactUseCaseProvider = Provider<DeleteContactUsecase>((ref) {
  final repository = ref.watch(contactRepositoryProvider);
  return DeleteContactUsecase(repository);
});

// Provider
final watchContactProvider = StreamProvider<List<Contact>>((ref) {
  final useCase = ref.watch(watchContactsUseCaseProvider);
  return useCase(); // llama al método call()
});
