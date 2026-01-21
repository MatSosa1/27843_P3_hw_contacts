import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hw_contacts/presentation/pages/home_page.dart';
import 'package:hw_contacts/presentation/providers/contact_provider.dart';
import 'package:hw_contacts/domain/entities/contact.dart';

void main() {
  testWidgets('Al presionar el botón flotante se muestra el formulario de nuevo contacto', (WidgetTester tester) async {
    // Mock del provider para devolver al menos un contacto
    final container = ProviderContainer(overrides: [
      watchContactProvider.overrideWith((ref) => Stream.value([
        Contact(id: 1, name: 'Juan Perez', phone: '123456789', email: 'juan@mail.com'),
      ])),
    ]);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Nuevo contacto'), findsOneWidget);
  });
}
