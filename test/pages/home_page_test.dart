import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hw_contacts/domain/entities/contact.dart';
import 'package:hw_contacts/presentation/pages/home_page.dart';
import 'package:hw_contacts/presentation/providers/contact_provider.dart';
import 'package:hw_contacts/presentation/widgets/contact_tile.dart';

void main() {
  testWidgets('HomePage muestra Loading inicialmente', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: HomePage()),
      ),
    );

    // Por defecto un StreamProvider inicia en loading si no tiene valor inicial
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('HomePage muestra mensaje cuando no hay contactos', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Sobrescribimos el StreamProvider para emitir una lista vacía
          watchContactProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: const MaterialApp(home: HomePage()),
      ),
    );

    await tester.pumpAndSettle(); // Esperar a que el stream emita

    expect(find.text('No contacts'), findsOneWidget);
  });

  testWidgets('HomePage muestra lista de contactos correctamente', (tester) async {
    final contacts = [
      Contact(id: 1, name: 'Ana', phone: '123', email: 'ana@a.com'),
      Contact(id: 2, name: 'Beto', phone: '456', email: 'beto@b.com'),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Simulamos lista con datos
          watchContactProvider.overrideWith((ref) => Stream.value(contacts)),
        ],
        child: const MaterialApp(home: HomePage()),
      ),
    );

    await tester.pumpAndSettle();

    // Verificamos que aparecen los Tiles
    expect(find.byType(ContactTile), findsNWidgets(2));
    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Beto'), findsOneWidget);
    
    // Verificamos que aparece el índice alfabético
    expect(find.text('A'), findsWidgets); // Aparece en el avatar y quizás en el índice
  });
}