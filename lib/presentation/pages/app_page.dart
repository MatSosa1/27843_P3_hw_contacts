import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hw_contacts/presentation/providers/contact_provider.dart';
import 'package:hw_contacts/presentation/widgets/bottom_nav.dart';

import 'home_page.dart';
import 'favorites_page.dart';

class AppPage extends ConsumerWidget {
  const AppPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [
          HomePage(),
          FavoritesPage(),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
