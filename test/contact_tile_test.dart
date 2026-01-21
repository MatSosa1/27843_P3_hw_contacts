import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hw_contacts/application/usecases/delete_contact_usecase.dart';
import 'package:hw_contacts/domain/entities/contact.dart';
import 'package:hw_contacts/domain/repositories/contact_repository.dart';
import 'package:hw_contacts/presentation/providers/contact_provider.dart';
import 'package:hw_contacts/presentation/widgets/contact_tile.dart';
import 'package:mockito/mockito.dart';

class FakeContactRepository implements ContactRepository {
  @override
  Future<void> addContact(c) async {}
  @override
  Future<void> deleteContact(id) async {}
  @override
  Future<List<Contact>> getAllContacts() async => [];
  @override
  Future<void> toggleFavorite(id) async {}
  @override
  Stream<List<Contact>> watchContacts() => Stream.value([]);
  @override
  Stream<List<Contact>> watchFavoriteContacts() => Stream.value([]);
}

class MockDeleteContactUsecase extends DeleteContactUsecase {
  bool deleted = false;
  MockDeleteContactUsecase(ContactRepository repo)
      : super(repo);
  @override
  Future<void> call(int id) async {
    deleted = true;
  }
}

void main() {
  group('ContactTile Widget', () {
    testWidgets('Muestra el nombre y teléfono del contacto', (
      WidgetTester tester,
    ) async {
      final contact = Contact(
        id: 1,
        name: 'Juan Perez',
        phone: '123456789',
        email: 'juan@mail.com',
      );
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ContactTile(contact: contact)),
          ),
        ),
      );
      expect(find.text('Juan Perez'), findsOneWidget);
      expect(find.text('123456789'), findsOneWidget);
    });

    testWidgets('Elimina contacto al presionar el botón de borrar', (WidgetTester tester) async {
      final contact = Contact(id: 2, name: 'Ana Lopez', phone: '987654321', email: 'ana@mail.com');
      final mockRepo = FakeContactRepository();
      final mockDelete = MockDeleteContactUsecase(mockRepo);
      final container = ProviderContainer(overrides: [
        deleteContactUseCaseProvider.overrideWith((ref) => mockDelete),
      ]);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: ContactTile(contact: contact),
            ),
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();
      expect(mockDelete.deleted, isTrue);
    });

    testWidgets('Muestra el modal de acciones al hacer tap', (
      WidgetTester tester,
    ) async {
      final contact = Contact(
        id: 3,
        name: 'Luis Ruiz',
        phone: '555555555',
        email: 'luis@mail.com',
      );
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ContactTile(contact: contact)),
          ),
        ),
      );
      await tester.tap(find.text('Luis Ruiz'));
      await tester.pumpAndSettle();
      expect(find.text('Llamar'), findsOneWidget);
      expect(find.text('Enviar correo'), findsOneWidget);
    });
  });
}
