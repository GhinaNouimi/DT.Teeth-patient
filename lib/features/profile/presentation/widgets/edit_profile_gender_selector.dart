import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class EditProfileGenderSelector extends StatelessWidget {
  final int selectedGender;
  final bool enabled;
  final ValueChanged<int> onChanged;

  const EditProfileGenderSelector({
    super.key,
    required this.selectedGender,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    Widget item(String label, int value) {
      final isSelected = selectedGender == value;

      return Expanded(
        child: InkWell(
          onTap: enabled ? () => onChanged(value) : null,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.surfaceSecondary
                  : colors.surfaceMuted.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? colors.navBarItem.withValues(alpha: 0.12)
                    : colors.borderSoft,
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الجنس',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            item('ذكر', 1),
            const SizedBox(width: 10),
            item('أنثى', 0),
          ],
        ),
      ],
    );
  }
}