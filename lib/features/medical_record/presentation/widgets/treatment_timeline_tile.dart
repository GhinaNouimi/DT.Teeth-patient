import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/treatment_timeline_step_entity.dart';
import '../utils/medical_record_accent.dart';

class TreatmentTimelineTile extends StatelessWidget {
  final TreatmentTimelineStepEntity step;
  final bool isLast;

  const TreatmentTimelineTile({
    super.key,
    required this.step,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final accent = context.medicalAccent;
    final dotColor = switch (step.state) {
      TreatmentTimelineStepState.completed => colors.success,
      TreatmentTimelineStepState.current => accent,
      TreatmentTimelineStepState.upcoming => colors.borderSoft,
    };

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: step.state == TreatmentTimelineStepState.upcoming
                      ? colors.surfacePrimary
                      : dotColor.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                  border: Border.all(color: dotColor, width: 2.6),
                ),
                child: step.state == TreatmentTimelineStepState.completed
                    ? Icon(Icons.check_rounded, size: 13, color: colors.success)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.borderSoft,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: step.state == TreatmentTimelineStepState.current
                    ? accent.withValues(alpha: 0.08)
                    : colors.surfacePrimary,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: step.state == TreatmentTimelineStepState.current
                      ? accent.withValues(alpha: 0.24)
                      : colors.borderSoft,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    step.dateLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (step.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      step.subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: step.state == TreatmentTimelineStepState.current
                            ? accent
                            : colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
