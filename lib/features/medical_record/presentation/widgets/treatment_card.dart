import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/common/app_section_card.dart';
import '../../domain/entities/treatment/treatment_entity.dart';
import '../utils/medical_record_accent.dart';
import 'treatment_progress_ring.dart';
import 'treatment_status_chip.dart';

class TreatmentCard extends StatelessWidget {
  final TreatmentEntity treatment;
  final VoidCallback onTap;

  const TreatmentCard({
    super.key,
    required this.treatment,
    required this.onTap,
  });

  int get _progressPercent {
    if (treatment.totalSessionsNeeded == 0) {
      return 0;
    }

    return ((treatment.sessionsCompleted / treatment.totalSessionsNeeded) * 100)
        .round()
        .clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final accent = context.medicalAccent;
    final pink = context.medicalPinkAccent;
    final l10n = context.l10n;
    final languageCode = Localizations.localeOf(context).languageCode;

    final treatmentName = treatment.treatmentType.localizedName(
      languageCode,
    );

    final progressLabel = l10n.completedSessions(
      treatment.sessionsCompleted,
      treatment.totalSessionsNeeded,
    );

    return AppSectionCard(
      onTap: onTap,
      radius: AppRadius.xl,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      treatmentName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      treatment.dentist.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              TreatmentProgressRing(
                percent: _progressPercent,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              TreatmentStatusChip(
                status: treatment.status,
              ),
              const Spacer(),
              Text(
                progressLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: pink.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(
                AppRadius.lg,
              ),
              border: Border.all(
                color: pink.withValues(alpha: 0.55),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  color: accent,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.treatmentCreatedAt,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        treatment.createdAt,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if ((treatment.notes ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    treatment.notes!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                TextButton.icon(
                  onPressed: onTap,
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                  ),
                  label: Text(
                    l10n.details,
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 14),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: onTap,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                ),
                label: Text(
                  l10n.details,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}