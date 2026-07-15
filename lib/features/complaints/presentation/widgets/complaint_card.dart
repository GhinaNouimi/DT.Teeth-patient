import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/complaint_entity.dart';
import 'complaint_priority_chip.dart';
import 'complaint_status_chip.dart';

class ComplaintCard extends StatelessWidget {
  final ComplaintEntity complaint;
  final VoidCallback onTap;

  const ComplaintCard({
    super.key,
    required this.complaint,
    required this.onTap,
  });

  String _formatDate(
      BuildContext context,
      DateTime date,
      ) {
    final languageCode =
        Localizations.localeOf(context).languageCode;

    return DateFormat(
      'dd MMM yyyy',
      languageCode,
    ).format(date);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: colors.surfacePrimary,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: colors.borderSoft),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: colors.surfaceMuted,
                      borderRadius: BorderRadius.circular(
                        AppRadius.lg,
                      ),
                    ),
                    child: Icon(
                      Icons.support_agent_rounded,
                      color: colors.navBarItem,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          complaint.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                          theme.textTheme.titleMedium?.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w800,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${l10n.complaintNumber} #${complaint.id}',
                          style:
                          theme.textTheme.bodySmall?.copyWith(
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: colors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                complaint.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                  height: 1.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  ComplaintStatusChip(
                    status: complaint.status,
                  ),
                  ComplaintPriorityChip(
                    priority: complaint.priority,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Divider(
                height: 1,
                color: colors.borderSoft,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: colors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _formatDate(
                        context,
                        complaint.createdAt,
                      ),
                      style:
                      theme.textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (complaint.hasAdminResponse) ...[
                    Icon(
                      Icons.mark_chat_read_outlined,
                      size: 17,
                      color: colors.success,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      l10n.complaintAdminResponse,
                      style:
                      theme.textTheme.bodySmall?.copyWith(
                        color: colors.success,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}