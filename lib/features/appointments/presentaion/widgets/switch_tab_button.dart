import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class SwitchTabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  const SwitchTabButton({
    super.key,
    required this.label,
    required this.icon,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isActive
            ? colors.textPrimary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? colors.textPrimary
              : colors.borderSoft,
        ),
        boxShadow: isActive
            ? [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isActive
                      ? Colors.white
                      : colors.textSecondary,
                ),

                const SizedBox(width: 8),

                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isActive
                        ? Colors.white
                        : colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(width: 8),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withValues(alpha: 0.16)
                        : colors.surfaceMuted,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$count',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isActive
                          ? Colors.white
                          : colors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}