import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class EditProfileReadOnlyField extends StatelessWidget {
  final String label;
  final String value;

  const EditProfileReadOnlyField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surfaceMuted.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.borderSoft.withValues(alpha: 0.75),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 16,
                color: colors.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  value,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}