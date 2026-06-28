import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/common/app_section_card.dart';
import '../../../../core/widgets/common/app_status_chip.dart';
import '../../domain/entities/complaint_entity.dart';

class ComplaintCard extends StatelessWidget {
  final ComplaintEntity complaint;
  final VoidCallback onTap;

  const ComplaintCard({
    super.key,
    required this.complaint,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _categoryLabel(ComplaintCategory category) {
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

  IconData _categoryIcon(ComplaintCategory category) {
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

  String _statusLabel(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.open:
        return 'تم الاستلام';
      case ComplaintStatus.inProgress:
        return 'قيد المعالجة';
      case ComplaintStatus.resolved:
        return 'تم الحل';
    }
  }

  AppStatusType _statusType(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.open:
        return AppStatusType.info;
      case ComplaintStatus.inProgress:
        return AppStatusType.warning;
      case ComplaintStatus.resolved:
        return AppStatusType.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return AppSectionCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(
              _categoryIcon(complaint.category),
              color: colors.navBarItem,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        complaint.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    AppStatusChip(
                      label: _statusLabel(complaint.status),
                      type: _statusType(complaint.status),
                      isCompact: true,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  complaint.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Icon(
                      Icons.tag_rounded,
                      size: 15,
                      color: colors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      _categoryLabel(complaint.category),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Icon(
                      Icons.schedule_rounded,
                      size: 15,
                      color: colors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      _formatDate(complaint.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surfaceMuted,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(color: colors.borderSoft),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'عرض التفاصيل',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: colors.navBarItem,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}