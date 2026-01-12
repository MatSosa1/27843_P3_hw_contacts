import 'package:flutter/material.dart';

class ContactsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ContactsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFDF6EE),
      elevation: 0,
      title: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      actions: const [
        Icon(Icons.filter_list),
        SizedBox(width: 12),
        Icon(Icons.more_vert),
        SizedBox(width: 12),
      ],
    );
  }
}
