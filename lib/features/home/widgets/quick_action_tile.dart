import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isEmergency;
  final VoidCallback? onTap;

  const QuickActionTile({
    super.key,
    required this.icon,
    required this.label,
    this.isEmergency = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    final backgroundColor =
    isEmergency
        ? colors.danger.withValues(alpha: 0.10)
        : colors.surfacePrimary;

    final iconBackgroundColor =
    isEmergency
        ? colors.danger.withValues(alpha: 0.16)
        : colors.surfaceMuted;

    final iconColor =
    isEmergency
        ? colors.danger
        : colors.navBarItem;

    final borderColor =
    isEmergency
        ? colors.danger.withValues(alpha: 0.22)
        : colors.borderSoft;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 158,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}