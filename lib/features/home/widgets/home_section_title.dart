import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class HomeSectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const HomeSectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (actionText != null)
          TextButton(onPressed: onActionTap, child: Text(actionText!)),
      ],
    );
  }
}
