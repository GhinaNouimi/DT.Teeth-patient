import 'package:flutter/material.dart';

import '../../../core/theme/theme_extensions.dart';

enum QuickActionCircleType {
  booking,
  contact,
  ai,
}

class QuickActionCircleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final QuickActionCircleType type;
  final VoidCallback? onTap;

  const QuickActionCircleTile({
    super.key,
    required this.icon,
    required this.label,
    required this.type,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    final actionColors = _resolveColors(
      colors,
    );

    return Expanded(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: actionColors.background,
                    border: Border.all(
                      color: actionColors.border,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: actionColors.glow,
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: actionColors.icon,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _QuickActionVisualColors _resolveColors(
      dynamic colors,
      ) {
    switch (type) {
      case QuickActionCircleType.booking:
        return _QuickActionVisualColors(
          background: colors.buttonPrimary
              .withValues(alpha: 0.12),
          border: colors.buttonPrimary
              .withValues(alpha: 0.26),
          icon: colors.buttonPrimary,
          glow: colors.buttonPrimary
              .withValues(alpha: 0.14),
        );

      case QuickActionCircleType.contact:
        return _QuickActionVisualColors(
          background: colors.surfaceMuted,
          border: colors.borderSoft,
          icon: colors.navBarItem,
          glow: colors.shadow,
        );

      case QuickActionCircleType.ai:
        return _QuickActionVisualColors(
          background: colors.reservedState
              .withValues(alpha: 0.75),
          border: colors.success
              .withValues(alpha: 0.22),
          icon: colors.success,
          glow: colors.success
              .withValues(alpha: 0.12),
        );
    }
  }
}

class _QuickActionVisualColors {
  final Color background;
  final Color border;
  final Color icon;
  final Color glow;

  const _QuickActionVisualColors({
    required this.background,
    required this.border,
    required this.icon,
    required this.glow,
  });
}