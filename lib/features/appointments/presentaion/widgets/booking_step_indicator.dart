import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';

class BookingStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool isContinueTreatment;

  const BookingStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.isContinueTreatment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    final titles = isContinueTreatment
        ? [
      l10n.selectBookingTypeTitle,
      l10n.selectTreatmentTitle,
      l10n.appointmentTypeLabel,
      l10n.selectDentistTitle,
      l10n.selectAppointmentTimeTitle,
      l10n.appointmentNotesTitle,
      l10n.reviewAppointmentRequestTitle,
    ]
        : [
      l10n.selectBookingTypeTitle,
      l10n.appointmentTypeLabel,
      l10n.selectDentistTitle,
      l10n.selectAppointmentTimeTitle,
      l10n.appointmentNotesTitle,
      l10n.reviewAppointmentRequestTitle,
    ];

    final safeStep = currentStep.clamp(
      0,
      titles.length - 1,
    );

    final safeTotalSteps = totalSteps.clamp(
      1,
      titles.length,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.appointmentBookingStep(
            safeStep + 1,
            safeTotalSteps,
          ),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          titles[safeStep],
          style: theme.textTheme.titleLarge?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: List.generate(
            safeTotalSteps,
                (index) {
              final isActive = index <= safeStep;
              final isLast =
                  index == safeTotalSteps - 1;

              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 220,
                  ),
                  curve: Curves.easeOut,
                  margin: EdgeInsetsDirectional.only(
                    end: isLast ? 0 : 8,
                  ),
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive
                        ? colors.buttonPrimary
                        : colors.surfaceMuted,
                    borderRadius:
                    BorderRadius.circular(99),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}