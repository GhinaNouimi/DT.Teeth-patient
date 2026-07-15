import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/complaint_entity.dart';

class ComplaintStatusChip extends StatelessWidget {
  final ComplaintStatus status;

  const ComplaintStatusChip({
    super.key,
    required this.status,
  });

  String _label(BuildContext context) {
    final l10n = context.l10n;

    switch (status) {
      case ComplaintStatus.pending:
        return l10n.complaintStatusPending;
      case ComplaintStatus.inProgress:
        return l10n.complaintStatusInProgress;
      case ComplaintStatus.resolved:
        return l10n.complaintStatusResolved;
      case ComplaintStatus.rejected:
        return l10n.complaintStatusRejected;
      case ComplaintStatus.unknown:
        return l10n.complaintStatusUnknown;
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
    late final IconData icon;

    switch (status) {
      case ComplaintStatus.pending:
        backgroundColor = isDark
            ? const Color(0xFF493A16)
            : const Color(0xFFFFF3CD);
        textColor = isDark
            ? const Color(0xFFFFD76A)
            : const Color(0xFF8A5A00);
        borderColor = isDark
            ? const Color(0xFF7A6226)
            : const Color(0xFFE4BE62);
        icon = Icons.schedule_rounded;

      case ComplaintStatus.inProgress:
        backgroundColor = isDark
            ? const Color(0xFF172E54)
            : const Color(0xFFE8F0FF);
        textColor = isDark
            ? const Color(0xFF8DB8FF)
            : const Color(0xFF2457A7);
        borderColor = isDark
            ? const Color(0xFF31558A)
            : const Color(0xFFA9C2EC);
        icon = Icons.sync_rounded;

      case ComplaintStatus.resolved:
        backgroundColor = isDark
            ? const Color(0xFF163B26)
            : const Color(0xFFE4F6EA);
        textColor = isDark
            ? const Color(0xFF79D69A)
            : const Color(0xFF237A42);
        borderColor = isDark
            ? const Color(0xFF2F6844)
            : const Color(0xFF9DD4AD);
        icon = Icons.check_circle_outline_rounded;

      case ComplaintStatus.rejected:
        backgroundColor = isDark
            ? const Color(0xFF4B2020)
            : const Color(0xFFFDE8E8);
        textColor = isDark
            ? const Color(0xFFFF9999)
            : const Color(0xFFB13A3A);
        borderColor = isDark
            ? const Color(0xFF7B3C3C)
            : const Color(0xFFE8AAAA);
        icon = Icons.cancel_outlined;

      case ComplaintStatus.unknown:
        backgroundColor = colors.surfaceMuted;
        textColor = colors.textSecondary;
        borderColor = colors.borderSoft;
        icon = Icons.help_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: textColor,
          ),
          const SizedBox(width: 5),
          Text(
            _label(context),
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}