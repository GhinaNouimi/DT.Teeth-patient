import 'package:flutter/material.dart';

import '../../../../core/theme/app_color_tokens.dart';

class BookingInfoBanner extends StatelessWidget {
  final AppColorTokens colors;
  final ThemeData theme;
  final IconData icon;
  final String text;
  final Color? iconColor;

  const BookingInfoBanner({
    super.key,
    required this.colors,
    required this.theme,
    required this.icon,
    required this.text,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? colors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
