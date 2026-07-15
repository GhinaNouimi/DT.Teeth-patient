import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/complaint_entity.dart';

class ComplaintPriorityChip extends StatelessWidget {
  final ComplaintPriority priority;

  const ComplaintPriorityChip({
    super.key,
    required this.priority,
  });

  String _label(BuildContext context) {
    final l10n = context.l10n;

    switch (priority) {
      case ComplaintPriority.low:
        return l10n.complaintPriorityLow;

      case ComplaintPriority.medium:
        return l10n.complaintPriorityMedium;

      case ComplaintPriority.high:
        return l10n.complaintPriorityHigh;

      case ComplaintPriority.unknown:
        return l10n.complaintPriorityUnknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    late final Color backgroundColor;
    late final Color textColor;
    late final Color borderColor;

    switch (priority) {
      case ComplaintPriority.low:
        backgroundColor = isDark
            ? const Color(0xFF163B26)
            : const Color(0xFFE4F6EA);

        textColor = isDark
            ? const Color(0xFF79D69A)
            : const Color(0xFF237A42);

        borderColor = isDark
            ? const Color(0xFF2F6844)
            : const Color(0xFF9DD4AD);

      case ComplaintPriority.medium:
        backgroundColor = isDark
            ? const Color(0xFF493A16)
            : const Color(0xFFFFF3CD);

        textColor = isDark
            ? const Color(0xFFFFD76A)
            : const Color(0xFF8A5A00);

        borderColor = isDark
            ? const Color(0xFF7A6226)
            : const Color(0xFFE4BE62);

      case ComplaintPriority.high:
        backgroundColor = isDark
            ? const Color(0xFF4B2020)
            : const Color(0xFFFDE8E8);

        textColor = isDark
            ? const Color(0xFFFF9999)
            : const Color(0xFFB13A3A);

        borderColor = isDark
            ? const Color(0xFF7B3C3C)
            : const Color(0xFFE8AAAA);

      case ComplaintPriority.unknown:
        backgroundColor = colors.surfaceMuted;
        textColor = colors.textSecondary;
        borderColor = colors.borderSoft;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Text(
        _label(context),
        style: theme.textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}