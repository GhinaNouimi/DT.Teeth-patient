import 'package:flutter/material.dart';

import '../../../../../core/theme/theme_extensions.dart';


class AppointmentDayChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool available;
  final VoidCallback? onTap;

  const AppointmentDayChip({
    super.key,
    required this.label,
    required this.selected,
    this.available = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    final backgroundColor = !available
        ? colors.backgroundSecondary
        : selected
        ? colors.buttonPrimary
        : colors.surfaceMuted;

    final textColor = !available
        ? colors.textSecondary.withValues(alpha: 0.55)
        : selected
        ? Colors.white
        : colors.textPrimary;

    final borderColor = !available
        ? colors.borderSoft
        : selected
        ? colors.buttonPrimary
        : colors.borderSoft;

    return InkWell(
      onTap: available ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
