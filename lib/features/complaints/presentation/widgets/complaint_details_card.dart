import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/common/app_section_card.dart';
import '../../../../core/widgets/common/app_status_chip.dart';
import '../../domain/entities/complaint_entity.dart';
import 'complaint_category_chip.dart';
import 'complaint_info_row.dart';
import 'complaint_status_progress.dart';

class ComplaintDetailsCard extends StatelessWidget {
  final ComplaintEntity complaint;

  const ComplaintDetailsCard({
    super.key,
    required this.complaint,
  });

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
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

    final hasCenterReply =
        complaint.centerReply != null && complaint.centerReply!.trim().isNotEmpty;

    return Column(
      children: [
        AppSectionCard(
          radius: AppRadius.xl,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      complaint.title,
                      style: theme.textTheme.titleLarge?.copyWith(
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
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  ComplaintCategoryChip(category: complaint.category),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    complaint.id,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        ComplaintStatusProgress(status: complaint.status),
        const SizedBox(height: AppSpacing.lg),

        AppSectionCard(
          radius: AppRadius.xl,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تفاصيل الشكوى',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ComplaintInfoRow(
                label: 'وصف الشكوى',
                value: complaint.description,
                icon: Icons.description_outlined,
              ),
              const SizedBox(height: AppSpacing.lg),
              ComplaintInfoRow(
                label: 'تاريخ الإرسال',
                value: _formatDate(complaint.createdAt),
                icon: Icons.schedule_rounded,
              ),
              if (complaint.relatedReference != null &&
                  complaint.relatedReference!.trim().isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                ComplaintInfoRow(
                  label: 'مرجع مرتبط',
                  value: complaint.relatedReference!,
                  icon: Icons.link_rounded,
                ),
              ],
            ],
          ),
        ),

        if (complaint.status == ComplaintStatus.resolved && hasCenterReply) ...[
          const SizedBox(height: AppSpacing.lg),
          AppSectionCard(
            radius: AppRadius.xl,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: colors.reservedState,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Icon(
                        Icons.mark_chat_read_rounded,
                        color: colors.success,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'رد المركز',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  complaint.centerReply!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (complaint.resolvedAt != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  ComplaintInfoRow(
                    label: 'تاريخ الحل',
                    value: _formatDate(complaint.resolvedAt!),
                    icon: Icons.verified_rounded,
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}