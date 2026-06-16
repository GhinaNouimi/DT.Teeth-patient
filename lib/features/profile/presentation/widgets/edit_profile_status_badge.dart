import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class EditProfileStatusBadge extends StatelessWidget {
  final bool isEditing;

  const EditProfileStatusBadge({
    super.key,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isEditing
            ? colors.surfaceSecondary
            : colors.surfaceMuted.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        isEditing ? 'وضع التعديل' : 'وضع الاستعراض',
        style: theme.textTheme.bodySmall?.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}