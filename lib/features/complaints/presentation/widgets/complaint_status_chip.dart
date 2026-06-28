import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/complaint_entity.dart';

class ComplaintStatusChip extends StatelessWidget {
  final ComplaintStatus status;

  const ComplaintStatusChip({
    super.key,
    required this.status,
  });

  String get _label {
    switch (status) {
      case ComplaintStatus.open:
        return 'مفتوحة';
      case ComplaintStatus.inProgress:
        return 'قيد المعالجة';
      case ComplaintStatus.resolved:
        return 'تم الحل';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    late final Color backgroundColor;
    late final Color textColor;
    late final Color borderColor;

    switch (status) {
      case ComplaintStatus.open:
        backgroundColor = colors.surfaceMuted;
        textColor = colors.navBarItem;
        borderColor = colors.borderSoft;
        break;
      case ComplaintStatus.inProgress:
        backgroundColor = colors.warning.withValues(alpha: 0.22);
        textColor = const Color(0xFF9A5B00);
        borderColor = colors.warning.withValues(alpha: 0.45);
        break;
      case ComplaintStatus.resolved:
        backgroundColor = colors.success.withValues(alpha: 0.16);
        textColor = colors.success;
        borderColor = colors.success.withValues(alpha: 0.28);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        _label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}