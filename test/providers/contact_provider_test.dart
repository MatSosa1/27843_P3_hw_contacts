import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hw_contacts/domain/entities/contact.dart';
import 'package:hw_contacts/domain/repositories/contact_repository.dart';
import 'package:hw_contacts/presentation/providers/contact_provider.dart';

// --- Mocks ---
class MockContactRepository extends Mock implements ContactRepository {}

void main() {
  late MockContactRepository mockRepo;

  setUp(() {
    mockRepo = MockContactRepository();
    // Registramos valores por defecto por si acaso
    registerFallbackValue(Contact(id: 0, name: '', phone: '', email: ''));
  });

  // Helper para convertir los estados del provider en un Stream testeable
  Stream<AsyncValue<T>> monitorProvider<T>(ProviderContainer container, ProviderListenable<AsyncValue<T>> provider) {
    final controller = StreamController<AsyncValue<T>>();
    final sub = container.listen(
      provider,
      (_, next) => controller.add(next),
      fireImmediately: true,
    );
    addTearDown(() {
      sub.close();
      controller.close();
    });
    return controller.stream;
  }

  group('Contact Providers Test', () {
    test('bottomNavIndexProvider inicia en 0 y puede cambiar', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Valor inicial
      expect(container.read(bottomNavIndexProvider), 0);

      // Cambiar valor
      container.read(bottomNavIndexProvider.notifier).state = 1;
      expect(container.read(bottomNavIndexProvider), 1);
    });

    test('watchContactProvider emite contactos desde el repositorio', () async {
      final contacts = [
        Contact(id: 1, name: 'Ana', phone: '123', email: 'a@a.com'),
        Contact(id: 2, name: 'Beto', phone: '456', email: 'b@b.com'),
      ];

      // Simulamos el Stream del repositorio
      final streamController = StreamController<List<Contact>>.broadcast(sync: true);
      when(() => mockRepo.watchContacts()).thenAnswer((_) => streamController.stream);

      final container = ProviderContainer(
        overrides: [
          // Sobrescribimos el repositorio para que los UseCases usen nuestro Mock
          contactRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      // Verificamos estados: Loading -> Data
      expectLater(
        monitorProvider(container, watchContactProvider),
        emitsInOrder([
          isA<AsyncLoading<List<Contact>>>(),
          isA<AsyncData<List<Contact>>>()
              .having((d) => d.value.length, 'length', 2)
              .having((d) => d.value.first.name, 'name', 'Ana'),
        ]),
      );

      // Emitir datos
      streamController.add(contacts);
      
      // Limpieza del controller
      addTearDown(streamController.close);
    });

    test('watchFavoriteContactsProvider filtra solo favoritos (desde repo)', () async {
      final favorites = [
        Contact(id: 3, name: 'Carlos', phone: '777', email: 'c@c.com', isFavorite: true),
      ];

      final streamController = StreamController<List<Contact>>.broadcast(sync: true);
      when(() => mockRepo.watchFavoriteContacts()).thenAnswer((_) => streamController.stream);

      final container = ProviderContainer(
        overrides: [
          contactRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      expectLater(
        monitorProvider(container, watchFavoriteContactsProvider),
        emitsInOrder([
          isA<AsyncLoading<List<Contact>>>(),
          isA<AsyncData<List<Contact>>>()
              .having((d) => d.value.length, 'length', 1)
              .having((d) => d.value.first.isFavorite, 'isFavorite', true),
        ]),
      );

      streamController.add(favorites);
      addTearDown(streamController.close);
    });
  });

  group('UseCase Injection Test', () {
    test('Providers de UseCase obtienen el repositorio correctamente', () {
      final container = ProviderContainer(
        overrides: [
          contactRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      // Verificar que podemos leer los providers sin error
      final watchUseCase = container.read(watchContactsUseCaseProvider);
      final addUseCase = container.read(addContactUseCaseProvider);
      final deleteUseCase = container.read(deleteContactUseCaseProvider);

      expect(watchUseCase, isNotNull);
      expect(addUseCase, isNotNull);
      expect(deleteUseCase, isNotNull);
      
      // Si quisiéramos ser más estrictos, comprobaríamos que tienen el repo inyectado
      // pero como las propiedades son final y no públicas, basta con saber que se crearon.
    });
  });
}