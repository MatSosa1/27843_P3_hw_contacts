import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hw_contacts/presentation/providers/contact_provider.dart';

import 'package:hw_contacts/presentation/widgets/alphabet_index.dart';
import 'package:hw_contacts/presentation/widgets/contact_tile.dart';
import 'package:hw_contacts/presentation/widgets/contacts_app_bar.dart';
import 'package:hw_contacts/presentation/widgets/floating_buttons.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(watchContactProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EE),
      appBar: ContactsAppBar(),
      body: contactsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (contacts) {
          if (contacts.isEmpty) {
            return const Center(child: Text('No contacts'));
          }

          return Row(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    return ContactTile(contact: contacts[index]);
                  },
                ),
              ),

              const AlphabetIndex(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingButtons(ref),
    );
  }
}
