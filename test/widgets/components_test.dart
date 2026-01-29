import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hw_contacts/domain/entities/contact.dart';
import 'package:hw_contacts/presentation/widgets/contact_tile.dart';
import 'package:hw_contacts/presentation/widgets/add_contact_sheet.dart';
import 'package:hw_contacts/presentation/providers/contact_provider.dart';
import 'package:hw_contacts/application/usecases/delete_contact_usecase.dart';
import 'package:hw_contacts/application/usecases/add_contact_usecase.dart';

// Mocks de UseCases
class MockDeleteContactUsecase extends Mock implements DeleteContactUsecase {}
class MockAddContactUsecase extends Mock implements AddContactUsecase {}

void main() {
  setUpAll(() {
    registerFallbackValue(Contact(id: 0, name: '', phone: '', email: ''));
  });

  group('ContactTile Widget Test', () {
    testWidgets('Muestra información del contacto y botón eliminar funciona', (tester) async {
      final mockDeleteUseCase = MockDeleteContactUsecase();
      final contact = Contact(id: 1, name: 'Pepe', phone: '999', email: 'pepe@mail.com');

      // Configurar respuesta del mock
      when(() => mockDeleteUseCase.call(any())).thenAnswer((_) async {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            deleteContactUseCaseProvider.overrideWithValue(mockDeleteUseCase),
          ],
          child: MaterialApp(
            home: Scaffold(body: ContactTile(contact: contact)),
          ),
        ),
      );

      // 1. Validar visualización
      expect(find.text('Pepe'), findsOneWidget);
      expect(find.text('999'), findsOneWidget);
      expect(find.text('P'), findsOneWidget); // Inicial en el avatar

      // 2. Validar acción de eliminar
      final deleteBtn = find.byIcon(Icons.delete_outline);
      await tester.tap(deleteBtn);
      
      // Verificar que se llamó al UseCase con el ID correcto
      verify(() => mockDeleteUseCase.call(1)).called(1);
    });
  });

  group('AddContactSheet Widget Test', () {
    testWidgets('Valida formulario y guarda contacto', (tester) async {
      final mockAddUseCase = MockAddContactUsecase();
      when(() => mockAddUseCase.call(any())).thenAnswer((_) async {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            addContactUseCaseProvider.overrideWithValue(mockAddUseCase),
          ],
          child: const MaterialApp(
            home: Scaffold(body: AddContactSheet()),
          ),
        ),
      );

      // 1. Intentar guardar vacío (Debe fallar validación)
      await tester.tap(find.text('Guardar'));
      await tester.pump();
      expect(find.text('Campo obligatorio'), findsOneWidget);

      // 2. Llenar formulario
      await tester.enterText(find.widgetWithText(TextFormField, 'Nombre'), 'Nuevo User');
      await tester.enterText(find.widgetWithText(TextFormField, 'Teléfono'), '555555');
      await tester.enterText(find.widgetWithText(TextFormField, 'Correo'), 'new@test.com');

      // 3. Guardar correctamente
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle(); // Esperar a que cierre el modal/navegación

      // Verificar que se llamó al caso de uso con los datos correctos
      verify(() => mockAddUseCase.call(any(that: isA<Contact>()))).called(1);
    });
  });
}