import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/bookable_treatment_entity.dart';

class BookableTreatmentsSelectorWidget
    extends StatelessWidget {
  final List<BookableTreatmentEntity> treatments;
  final int? selectedTreatmentId;
  final bool isLoading;
  final String? errorMessage;
  final String languageCode;
  final ValueChanged<int> onTreatmentSelected;

  const BookableTreatmentsSelectorWidget({
    super.key,
    required this.treatments,
    required this.selectedTreatmentId,
    required this.isLoading,
    required this.errorMessage,
    required this.languageCode,
    required this.onTreatmentSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.selectTreatmentTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.selectTreatmentDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),

        if (isLoading)
          const _TreatmentsLoadingView()
        else if (errorMessage != null &&
            errorMessage!.trim().isNotEmpty)
          _TreatmentsMessageView(
            icon: Icons.error_outline_rounded,
            message: errorMessage!,
          )
        else if (treatments.isEmpty)
            _TreatmentsMessageView(
              icon: Icons.medical_services_outlined,
              message: l10n.noOngoingTreatmentsAvailable,
            )
          else
            Column(
              children: treatments.map((treatment) {
                final isSelected =
                    selectedTreatmentId == treatment.id;

                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: _TreatmentCard(
                    treatment: treatment,
                    languageCode: languageCode,
                    isSelected: isSelected,
                    onTap: () {
                      onTreatmentSelected(
                        treatment.id,
                      );
                    },
                  ),
                );
              }).toList(),
            ),
      ],
    );
  }
}

class _TreatmentCard extends StatelessWidget {
  final BookableTreatmentEntity treatment;
  final String languageCode;
  final bool isSelected;
  final VoidCallback onTap;

  const _TreatmentCard({
    required this.treatment,
    required this.languageCode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    final treatmentName =
    treatment.localizedTreatmentType(
      languageCode,
    );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 220,
          ),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.buttonPrimary
                .withValues(alpha: 0.10)
                : colors.surfacePrimary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? colors.buttonPrimary
                  : colors.borderSoft,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: colors.buttonPrimary
                      .withValues(alpha: 0.10),
                  borderRadius:
                  BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.medical_services_outlined,
                  color: colors.buttonPrimary,
                  size: 25,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      treatmentName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: theme
                          .textTheme.titleSmall
                          ?.copyWith(
                        color: colors.textPrimary,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      treatment.dentistName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: theme
                          .textTheme.bodySmall
                          ?.copyWith(
                        color: colors.textSecondary,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 9),
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: treatment.progress,
                        minHeight: 6,
                        backgroundColor:
                        colors.surfaceMuted,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      context.l10n
                          .remainingTreatmentSessions(
                        treatment.remainingSessions,
                      ),
                      style: theme
                          .textTheme.bodySmall
                          ?.copyWith(
                        color: colors.textSecondary,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons
                    .radio_button_unchecked_rounded,
                color: isSelected
                    ? colors.buttonPrimary
                    : colors.borderSoft,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TreatmentsLoadingView extends StatelessWidget {
  const _TreatmentsLoadingView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: List.generate(
        3,
            (index) => Padding(
          padding: const EdgeInsets.only(
            bottom: 12,
          ),
          child: Container(
            height: 110,
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              borderRadius:
              BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}

class _TreatmentsMessageView extends StatelessWidget {
  final IconData icon;
  final String message;

  const _TreatmentsMessageView({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 42,
            color: colors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}