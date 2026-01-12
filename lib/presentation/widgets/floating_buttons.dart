import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hw_contacts/domain/entities/contact.dart';
import 'package:hw_contacts/presentation/providers/contact_provider.dart';

class FloatingButtons extends StatelessWidget {
  final WidgetRef ref;

  const FloatingButtons(this.ref, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'dial',
          mini: true,
          backgroundColor: Colors.orange,
          onPressed: () {},
          child: const Icon(Icons.dialpad),
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: 'add',
          backgroundColor: Colors.orange,
          onPressed: () {
            ref.read(addContactUseCaseProvider)(
              Contact(
                id: 0,
                name: 'Mateo Sosa',
                phone: '0987654321',
                email: 'mateososa@test.com',
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
