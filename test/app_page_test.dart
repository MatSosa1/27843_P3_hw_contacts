import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hw_contacts/presentation/pages/app_page.dart';
import 'package:hw_contacts/domain/entities/contact.dart';
import 'package:hw_contacts/presentation/providers/contact_provider.dart';

void main() {
  group('AppPage Widget', () {
    testWidgets('Navega entre Contactos y Favoritos', (WidgetTester tester) async {
      // Mock de los providers para devolver streams vacíos
      final container = ProviderContainer(overrides: [
        watchContactProvider.overrideWith((ref) => Stream.value(<Contact>[])),
        watchFavoriteContactsProvider.overrideWith((ref) => Stream.value(<Contact>[])),
      ]);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: AppPage(),
          ),
        ),
      );
      // Cambia a la pestaña de favoritos
      await tester.tap(find.byIcon(Icons.star_border));
      await tester.pumpAndSettle();
      expect(find.text('No hay favoritos'), findsOneWidget);
    });
  });
}
