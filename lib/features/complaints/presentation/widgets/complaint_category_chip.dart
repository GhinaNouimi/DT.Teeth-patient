import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/complaint_entity.dart';

class ComplaintCategoryChip extends StatelessWidget {
  final ComplaintCategory category;

  const ComplaintCategoryChip({
    super.key,
    required this.category,
  });

  String get _label {
    switch (category) {
      case ComplaintCategory.appointment:
        return 'موعد';
      case ComplaintCategory.treatment:
        return 'علاج';
      case ComplaintCategory.payment:
        return 'دفعة';
      case ComplaintCategory.other:
        return 'أخرى';
    }
  }

  IconData get _icon {
    switch (category) {
      case ComplaintCategory.appointment:
        return Icons.calendar_month_outlined;
      case ComplaintCategory.treatment:
        return Icons.medical_services_outlined;
      case ComplaintCategory.payment:
        return Icons.receipt_long_outlined;
      case ComplaintCategory.other:
        return Icons.more_horiz_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _icon,
            size: 14,
            color: colors.navBarItem,
          ),
          const SizedBox(width: 6),
          Text(
            _label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}