import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_contact_sheet.dart';

class FloatingButtons extends ConsumerWidget {
  const FloatingButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // FloatingActionButton(
        //   heroTag: 'dial',
        //   mini: true,
        //   backgroundColor: Colors.orange,
        //   onPressed: () {},
        //   child: const Icon(Icons.dialpad),
        // ),
        // const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: 'add',
          backgroundColor: Colors.orange,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => const AddContactSheet(),
            );
          },
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
