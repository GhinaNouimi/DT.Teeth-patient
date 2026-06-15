import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class ProfileAvatarCard extends StatelessWidget {
  final String name;
  final String? avatarUrl;

  const ProfileAvatarCard({
    super.key,
    required this.name,
    required this.avatarUrl,
  });

  String _initials(String fullName) {
    final parts = fullName
        .trim()
        .split(' ')
        .where((element) => element.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return '؟';
    }

    if (parts.length == 1) {
      return parts.first.characters.first;
    }

    return '${parts.first.characters.first}${parts.last.characters.first}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    if (avatarUrl != null && avatarUrl!.trim().isNotEmpty) {
      return Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colors.borderSoft,
          ),
        ),
        child: ClipOval(
          child: Image.network(
            avatarUrl!,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.surfaceMuted,
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Center(
        child: Text(
          _initials(name),
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colors.navBarItem,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}