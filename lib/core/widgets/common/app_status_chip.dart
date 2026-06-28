import 'package:flutter/material.dart';

import '../../theme/theme_extensions.dart';

enum AppStatusType {
  info,
  success,
  warning,
  error,
  neutral,
}

class AppStatusChip extends StatelessWidget {
  final String label;
  final AppStatusType type;
  final IconData? icon;
  final bool isCompact;

  const AppStatusChip({
    super.key,
    required this.label,
    required this.type,
    this.icon,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = _resolveStyle(context, type);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 10 : 12,
        vertical: isCompact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: style.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: isCompact ? 14 : 16,
              color: style.foregroundColor,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: style.foregroundColor,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  _StatusChipStyle _resolveStyle(
      BuildContext context,
      AppStatusType type,
      ) {
    final colors = context.colors;

    switch (type) {
      case AppStatusType.info:
        return _StatusChipStyle(
          backgroundColor: colors.buttonSecondary.withValues(alpha: 0.32),
          borderColor: colors.buttonSecondary.withValues(alpha: 0.75),
          foregroundColor: colors.navBarItem,
        );

      case AppStatusType.success:
        return _StatusChipStyle(
          backgroundColor: colors.success.withValues(alpha: 0.13),
          borderColor: colors.success.withValues(alpha: 0.28),
          foregroundColor: colors.success,
        );

      case AppStatusType.warning:
        return _StatusChipStyle(
          backgroundColor: colors.warning.withValues(alpha: 0.55),
          borderColor: colors.warning.withValues(alpha: 0.95),
          foregroundColor: colors.textPrimary,
        );

      case AppStatusType.error:
        return _StatusChipStyle(
          backgroundColor: colors.danger.withValues(alpha: 0.12),
          borderColor: colors.danger.withValues(alpha: 0.26),
          foregroundColor: colors.danger,
        );

      case AppStatusType.neutral:
        return _StatusChipStyle(
          backgroundColor: colors.surfaceMuted,
          borderColor: colors.borderSoft,
          foregroundColor: colors.textSecondary,
        );
    }
  }
}

class _StatusChipStyle {
  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;

  const _StatusChipStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
  });
}