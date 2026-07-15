import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/common/app_section_card.dart';
import '../../domain/entities/complaint_entity.dart';
import 'complaint_info_row.dart';
import 'complaint_priority_chip.dart';
import 'complaint_status_chip.dart';

class ComplaintDetailsCard extends StatelessWidget {
  final ComplaintEntity complaint;

  const ComplaintDetailsCard({
    super.key,
    required this.complaint,
  });

  String _formatDate(
      BuildContext context,
      DateTime date,
      ) {
    final languageCode =
        Localizations.localeOf(context).languageCode;

    return DateFormat(
      'dd MMMM yyyy - HH:mm',
      languageCode,
    ).format(date);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Column(
      children: [
        AppSectionCard(
          radius: AppRadius.xl,
          padding: const EdgeInsets.all(
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colors.surfaceSecondary,
                      borderRadius:
                      BorderRadius.circular(
                        AppRadius.lg,
                      ),
                    ),
                    child: Icon(
                      Icons.support_agent_rounded,
                      color: colors.navBarItem,
                      size: 24,
                    ),
                  ),
                  const SizedBox(
                    width: AppSpacing.md,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          complaint.title,
                          style: theme
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                            color: colors.textPrimary,
                            fontWeight:
                            FontWeight.w800,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(
                          height: AppSpacing.xs,
                        ),
                        Text(
                          '${l10n.complaintNumber} #${complaint.id}',
                          style: theme
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color:
                            colors.textSecondary,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: AppSpacing.lg,
              ),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  ComplaintStatusChip(
                    status: complaint.status,
                  ),
                  ComplaintPriorityChip(
                    priority:
                    complaint.priority,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: AppSpacing.lg,
        ),
        AppSectionCard(
          radius: AppRadius.xl,
          padding: const EdgeInsets.all(
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                l10n.complaintBasicInformation,
                style: theme
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(
                height: AppSpacing.lg,
              ),
              ComplaintInfoRow(
                label:
                l10n.complaintDescription,
                value: complaint.description,
                icon:
                Icons.description_outlined,
              ),
              const SizedBox(
                height: AppSpacing.lg,
              ),
              ComplaintInfoRow(
                label:
                l10n.complaintSubmissionDate,
                value: _formatDate(
                  context,
                  complaint.createdAt,
                ),
                icon:
                Icons.calendar_today_outlined,
              ),
              const SizedBox(
                height: AppSpacing.lg,
              ),
              ComplaintInfoRow(
                label:
                l10n.complaintContactPhone,
                value: complaint.phoneNumber,
                icon: Icons.phone_outlined,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: AppSpacing.lg,
        ),
        _AdminResponseCard(
          response: complaint.adminResponse,
        ),
      ],
    );
  }
}

class _AdminResponseCard extends StatelessWidget {
  final String? response;

  const _AdminResponseCard({
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final l10n = context.l10n;

    final normalizedResponse =
        response?.trim() ?? '';

    final hasResponse =
        normalizedResponse.isNotEmpty;

    return AppSectionCard(
      radius: AppRadius.xl,
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: hasResponse
                      ? colors.success.withValues(
                    alpha: 0.12,
                  )
                      : colors.surfaceSecondary,
                  borderRadius:
                  BorderRadius.circular(
                    AppRadius.lg,
                  ),
                ),
                child: Icon(
                  hasResponse
                      ? Icons.mark_chat_read_rounded
                      : Icons.schedule_rounded,
                  color: hasResponse
                      ? colors.success
                      : colors.textSecondary,
                  size: 21,
                ),
              ),
              const SizedBox(
                width: AppSpacing.md,
              ),
              Expanded(
                child: Text(
                  l10n.complaintAdminResponse,
                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    color: colors.textPrimary,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: AppSpacing.lg,
          ),
          Text(
            hasResponse
                ? normalizedResponse
                : l10n
                .complaintNoAdminResponse,
            style: theme
                .textTheme
                .bodyMedium
                ?.copyWith(
              color: hasResponse
                  ? colors.textPrimary
                  : colors.textSecondary,
              height: 1.65,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}