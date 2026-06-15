import 'package:flutter/material.dart';

import '../../theme/theme_extensions.dart';
import '../branding/dental_smile_mark.dart';

class MainTabHeaderSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final Widget? trailing;

  const MainTabHeaderSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconBackgroundColor,
    this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (trailing != null) ...[
              trailing!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const DentalSmileMark(),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: iconBackgroundColor ?? colors.surfaceMuted,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: colors.borderSoft,
                ),
              ),
              child: Icon(
                icon,
                color: iconColor ?? colors.navBarItem,
                size: 26,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
            height: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}