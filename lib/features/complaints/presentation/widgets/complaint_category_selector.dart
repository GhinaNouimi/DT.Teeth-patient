import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/complaint_entity.dart';

class ComplaintCategorySelector extends StatelessWidget {
  final ComplaintCategory selectedCategory;
  final ValueChanged<ComplaintCategory> onChanged;

  const ComplaintCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  String _label(ComplaintCategory category) {
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

  IconData _icon(ComplaintCategory category) {
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

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: ComplaintCategory.values.map((category) {
        final isSelected = category == selectedCategory;

        return InkWell(
          onTap: () => onChanged(category),
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? colors.surfaceMuted : colors.surfacePrimary,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? colors.navBarItem.withValues(alpha: 0.18)
                    : colors.borderSoft,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _icon(category),
                  size: 18,
                  color: colors.navBarItem,
                ),
                const SizedBox(width: 8),
                Text(
                  _label(category),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}