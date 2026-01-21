import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hw_contacts/presentation/pages/home_page.dart';
import 'package:hw_contacts/presentation/providers/contact_provider.dart';
import 'package:hw_contacts/domain/entities/contact.dart';
import 'package:hw_contacts/presentation/widgets/alphabet_index.dart';

void main() {
  testWidgets('HomePage muestra el índice alfabético', (WidgetTester tester) async {
    // Mock del provider para devolver muchos contactos
    final contacts = List.generate(26, (i) => Contact(id: i, name: String.fromCharCode(65 + i), phone: '123', email: 'a@mail.com'));
    final container = ProviderContainer(overrides: [
      watchContactProvider.overrideWith((ref) => Stream.value(contacts)),
    ]);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Verifica que el widget AlphabetIndex está presente
    expect(find.byType(AlphabetIndex), findsOneWidget);
  });
}
