import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hw_contacts/application/usecases/add_contact_usecase.dart';
import 'package:hw_contacts/domain/entities/contact.dart';
import 'package:hw_contacts/presentation/widgets/add_contact_sheet.dart';
import 'package:hw_contacts/presentation/providers/contact_provider.dart';
import 'package:hw_contacts/domain/repositories/contact_repository.dart';

// Esta clase se utiliza para evitar errores de importación y generación con Mockito
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

void main() {
  group('AddContactSheet Widget', () {
    testWidgets('Muestra el formulario para nuevo contacto', (
      WidgetTester tester,
    ) async {
      final mockRepo = FakeContactRepository();
      final container = ProviderContainer(
        overrides: [
          addContactUseCaseProvider.overrideWith(
            (ref) => AddContactUsecase(mockRepo),
          ),
        ],
      );
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: Scaffold(body: AddContactSheet())),
        ),
      );
      expect(find.text('Nuevo contacto'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Nombre'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Teléfono'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Correo'), findsOneWidget);
    });

    testWidgets('No permite guardar si el nombre está vacío', (
      WidgetTester tester,
    ) async {
      final mockRepo = FakeContactRepository();
      final container = ProviderContainer(
        overrides: [
          addContactUseCaseProvider.overrideWith(
            (ref) => AddContactUsecase(mockRepo),
          ),
        ],
      );
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: Scaffold(body: AddContactSheet())),
        ),
      );
      await tester.tap(find.text('Guardar'));
      await tester.pump();
      expect(find.text('Campo obligatorio'), findsOneWidget);
    });
  });
}
