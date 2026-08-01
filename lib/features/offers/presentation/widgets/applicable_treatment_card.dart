import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/applicable_treatment_entity.dart';

class ApplicableTreatmentCard
    extends StatelessWidget {
  final ApplicableTreatmentEntity treatment;
  final bool isSelected;
  final VoidCallback? onTap;

  const ApplicableTreatmentCard({
    super.key,
    required this.treatment,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;
    final languageCode =
        Localizations.localeOf(context).languageCode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surfaceSecondary,
            borderRadius:
            BorderRadius.circular(20),
            border: Border.all(
              width: isSelected ? 2 : 1,
              color: isSelected
                  ? colors.navBarItem
                  : colors.borderSoft,
            ),
          ),
          child: Row(
            children: [
              Radio<int>(
                value: treatment.id,
                groupValue: isSelected
                    ? treatment.id
                    : null,
                onChanged: onTap == null
                    ? null
                    : (_) {
                  onTap?.call();
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      treatment.treatmentType
                          .localizedName(
                        languageCode,
                      ),
                      style: theme
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        color: colors.textPrimary,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.treatmentSessionsProgress(
                        treatment
                            .sessionsCompleted,
                        treatment
                            .totalSessionsNeeded,
                      ),
                      style: theme
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        color:
                        colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: treatment.progress,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}