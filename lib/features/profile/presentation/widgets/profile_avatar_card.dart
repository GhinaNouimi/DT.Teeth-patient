import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class ProfileAvatarCard extends StatelessWidget {
  final String name;
  final String? avatarStyleId;

  const ProfileAvatarCard({
    super.key,
    required this.name,
    required this.avatarStyleId,
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

  Color _backgroundColor(BuildContext context) {
    final colors = context.colors;

    switch (avatarStyleId) {
      case 'female_1':
        return const Color(0xFFF8DDF1);
      case 'female_2':
        return const Color(0xFFE8EEFF);
      case 'male_1':
        return const Color(0xFFE0EEFF);
      case 'male_2':
        return const Color(0xFFF3E5FF);
      default:
        return colors.surfaceMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _backgroundColor(context),
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