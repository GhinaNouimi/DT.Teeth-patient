import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class EditProfileSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final bool hasDivider;

  const EditProfileSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.enabled,
    required this.onChanged,
    this.hasDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surfaceMuted.withValues(alpha: 0.26),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: hasDivider
              ? colors.borderSoft.withValues(alpha: 0.7)
              : colors.borderSoft.withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeColor: colors.navBarItem,
            activeTrackColor: colors.surfaceSecondary,
          ),
        ],
      ),
    );
  }
}