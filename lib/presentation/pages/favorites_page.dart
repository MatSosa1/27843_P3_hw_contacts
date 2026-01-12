import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hw_contacts/presentation/providers/contact_provider.dart';
import 'package:hw_contacts/presentation/widgets/contact_tile.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(watchFavoriteContactsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (contacts) {
          if (contacts.isEmpty) {
            return const Center(child: Text('No hay favoritos'));
          }

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (_, i) => ContactTile(contact: contacts[i]),
          );
        },
      ),
    );
  }
}
