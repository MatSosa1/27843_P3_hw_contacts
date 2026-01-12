import 'package:flutter/material.dart';

class ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const ActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: color ?? theme.colorScheme.primary,
      ),
      title: Text(
        label,
        style: theme.textTheme.bodyLarge,
      ),
      onTap: onTap,
      dense: true,
    );
  }
}
