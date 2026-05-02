import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/theme_extensions.dart';

class AppTopBar extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final bool showBackButton;
  final VoidCallback? onBackTap;

  const AppTopBar({
    super.key,
    required this.title,
    this.trailing,
    this.showBackButton = true,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.backgroundSecondary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Row(
        children: [
          if (showBackButton)
            InkWell(
              onTap: onBackTap ?? () => context.pop(),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colors.surfacePrimary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.borderSoft),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: colors.navBarItem,
                ),
              ),
            ),
          if (showBackButton) const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
          ),
          if (trailing != null) trailing!,

        ],
      ),
    );
  }
}
