import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../widgets/edit_profile_status_badge.dart';

class EditProfileHeroSection extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final bool isEditing;

  const EditProfileHeroSection({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.isEditing,
  });

  String _initials(String fullName) {
    final parts = fullName
        .trim()
        .split(' ')
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'ن';
    if (parts.length == 1) return parts.first.characters.first;
    return '${parts.first.characters.first}${parts.last.characters.first}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.borderSoft),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: colors.surfaceSecondary,
              shape: BoxShape.circle,
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
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  email,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                EditProfileStatusBadge(isEditing: isEditing),
              ],
            ),
          ),
        ],
      ),
    );
  }
}