import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hw_contacts/domain/entities/contact.dart';
import 'package:hw_contacts/presentation/providers/contact_provider.dart';
import 'package:hw_contacts/presentation/widgets/action_tile.dart';
import 'package:url_launcher/url_launcher.dart';


class ContactTile extends ConsumerWidget {
  final Contact contact;

  const ContactTile({super.key, required this.contact});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () => _showActions(context, ref),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.orange.shade200,
        child: Text(
          contact.name[0].toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        contact.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(contact.phone),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () {
          ref.read(deleteContactUseCaseProvider)(contact.id);
        },
      ),
    );
  }

  void _showActions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ActionTile(
                  icon: Icons.call,
                  label: 'Llamar',
                  onTap: () async {
                    final uri = Uri(scheme: 'tel', path: contact.phone);
                    await launchUrl(uri);
                  },
                ),
                ActionTile(
                  icon: Icons.email,
                  label: 'Enviar correo',
                  onTap: () async {
                    final uri = Uri(
                      scheme: 'mailto',
                      path: contact.email,
                    );
                    await launchUrl(uri);
                  },
                ),
                ActionTile(
                  icon: contact.isFavorite
                      ? Icons.star
                      : Icons.star_border,
                  label: contact.isFavorite
                      ? 'Quitar de favoritos'
                      : 'Añadir a favoritos',
                  onTap: () {
                    ref
                        .read(toggleFavoriteContactUseCaseProvider)(
                          contact.id,
                        );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          )
        );
      },
    );
  }
}
