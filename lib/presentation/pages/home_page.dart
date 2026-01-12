import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hw_contacts/domain/entities/contact.dart';
import 'package:hw_contacts/presentation/providers/contact_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(watchContactProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: contactsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Text('Error: $error'),
        ),
        data: (contacts) {
          if (contacts.isEmpty) {
            return const Center(
              child: Text('No contacts yet'),
            );
          }

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final song = contacts[index];
              return _ContactTile(contact: song);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSong(ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addSong(WidgetRef ref) {
    final addSong = ref.read(addContactUseCaseProvider);

    addSong(
      Contact(
        id: 0, // ignored (autoIncrement)
        name: 'Mateo Sosa',
        phone: '0987654321',
        email: 'mateososa@test.com',
      ),
    );
  }
}

class _ContactTile extends ConsumerWidget {
  final Contact contact;

  const _ContactTile({required this.contact});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(contact.name),
      subtitle: Text(contact.phone),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          final deleteSong = ref.read(deleteContactUseCaseProvider);
          deleteSong(contact.id);
        },
      ),
    );
  }
}
