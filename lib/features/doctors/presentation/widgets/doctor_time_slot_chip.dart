import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class DoctorTimeSlotChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const DoctorTimeSlotChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? colors.buttonPrimary.withValues(alpha: 0.18)
              : colors.surfaceSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? colors.buttonPrimary : colors.borderSoft,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: selected ? colors.navBarItem : colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
