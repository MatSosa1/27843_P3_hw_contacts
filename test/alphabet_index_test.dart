import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hw_contacts/presentation/widgets/alphabet_index.dart';

void main() {
  testWidgets('AlphabetIndex muestra todas las letras', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AlphabetIndex(),
        ),
      ),
    );
    for (var letter in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')) {
      expect(find.text(letter), findsOneWidget);
    }
  });
}
