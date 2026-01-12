import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hw_contacts/presentation/providers/contact_provider.dart';

class BottomNav extends ConsumerWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavIndexProvider);

    return BottomNavigationBar(
      currentIndex: index,
      selectedItemColor: Colors.orange,
      onTap: (newIndex) {
        ref.read(bottomNavIndexProvider.notifier).state = newIndex;
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Contactos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_border),
          label: 'Favoritos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Grupos',
        ),
      ],
    );
  }
}
