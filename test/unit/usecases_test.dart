import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hw_contacts/domain/entities/contact.dart';
import 'package:hw_contacts/domain/repositories/contact_repository.dart';

// Importa tus UseCases
import 'package:hw_contacts/application/usecases/add_contact_usecase.dart';
import 'package:hw_contacts/application/usecases/delete_contact_usecase.dart';
import 'package:hw_contacts/application/usecases/get_contacts_usecase.dart';
import 'package:hw_contacts/application/usecases/toggle_favorite_contact_usecase.dart';
import 'package:hw_contacts/application/usecases/watch_contacts_usecase.dart';
import 'package:hw_contacts/application/usecases/watch_favorite_contacts_usecase.dart';

// 1. Mock del Repositorio
class MockContactRepository extends Mock implements ContactRepository {}

void main() {
  late MockContactRepository mockRepo;

  setUpAll(() {
    // Necesario para mocktail cuando usamos objetos personalizados en los argumentos
    registerFallbackValue(Contact(id: 0, name: '', phone: '', email: ''));
  });

  setUp(() {
    mockRepo = MockContactRepository();
  });

  group('UseCases Tests', () {
    
    // --- 1. AddContactUsecase ---
    test('AddContactUsecase llama a repo.addContact', () async {
      final useCase = AddContactUsecase(mockRepo);
      final contact = Contact(id: 0, name: 'Test', phone: '123', email: 'test@test.com');

      // Configurar
      when(() => mockRepo.addContact(any())).thenAnswer((_) async {});

      // Ejecutar
      await useCase(contact);

      // Verificar
      verify(() => mockRepo.addContact(contact)).called(1);
    });

    // --- 2. GetContactsUsecase ---
    test('GetContactsUsecase recupera lista de contactos', () async {
      final useCase = GetContactsUsecase(mockRepo);
      final contacts = [Contact(id: 1, name: 'A', phone: '1', email: 'a')];

      when(() => mockRepo.getAllContacts()).thenAnswer((_) async => contacts);

      final result = await useCase();

      expect(result, contacts);
      verify(() => mockRepo.getAllContacts()).called(1);
    });

    // --- 3. WatchContactsUsecase ---
    test('WatchContactsUsecase retorna stream de contactos', () {
      final useCase = WatchContactsUsecase(mockRepo);
      final contacts = [Contact(id: 1, name: 'A', phone: '1', email: 'a')];
      final stream = Stream.value(contacts);

      when(() => mockRepo.watchContacts()).thenAnswer((_) => stream);

      final result = useCase();

      expect(result, emits(contacts));
      verify(() => mockRepo.watchContacts()).called(1);
    });

    // --- 4. DeleteContactUsecase ---
    test('DeleteContactUsecase elimina contacto por ID', () async {
      final useCase = DeleteContactUsecase(mockRepo);
      const contactId = 5;

      when(() => mockRepo.deleteContact(any())).thenAnswer((_) async {});

      await useCase(contactId);

      verify(() => mockRepo.deleteContact(contactId)).called(1);
    });

    // --- 5. WatchFavoriteContactsUsecase ---
    test('WatchFavoriteContactsUsecase retorna stream de favoritos', () {
      final useCase = WatchFavoriteContactsUsecase(mockRepo);
      final favorites = [Contact(id: 2, name: 'B', phone: '2', email: 'b', isFavorite: true)];
      final stream = Stream.value(favorites);

      when(() => mockRepo.watchFavoriteContacts()).thenAnswer((_) => stream);

      final result = useCase();

      expect(result, emits(favorites));
      verify(() => mockRepo.watchFavoriteContacts()).called(1);
    });

    // --- 6. ToggleFavoriteContactUsecase ---
    test('ToggleFavoriteContactUsecase alterna estado de favorito', () async {
      final useCase = ToggleFavoriteContactUsecase(mockRepo);
      const contactId = 10;

      when(() => mockRepo.toggleFavorite(any())).thenAnswer((_) async {});

      await useCase(contactId);

      verify(() => mockRepo.toggleFavorite(contactId)).called(1);
    });

  });
}