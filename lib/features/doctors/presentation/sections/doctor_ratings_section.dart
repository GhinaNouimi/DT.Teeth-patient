import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_color_tokens.dart';
import '../widgets/doctor_section_title.dart';

class DoctorRatingsSection extends StatelessWidget {
  final int currentRating;
  final int userRating;
  final bool isSubmitting;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback onSubmitRating;
  final AppColorTokens colors;
  final ThemeData theme;

  const DoctorRatingsSection({
    super.key,
    required this.currentRating,
    required this.userRating,
    required this.isSubmitting,
    required this.onRatingChanged,
    required this.onSubmitRating,
    required this.colors,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoctorSectionTitle(
            title: l10n.rating,
            theme: theme,
            colors: colors,
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              ...List.generate(5, (index) {
                final isFilled = index < currentRating;

                return Icon(
                  isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                  color: isFilled ? colors.warning : colors.textSecondary,
                  size: 24,
                );
              }),
              const SizedBox(width: 10),
              Text(
                currentRating == 0 ? '-' : '$currentRating / 5',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const Divider(height: 32),

          Text(
            l10n.rateDentist,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final value = index + 1;
              final isSelected = value <= userRating;

              return GestureDetector(
                onTap: isSubmitting ? null : () => onRatingChanged(value),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    isSelected
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: isSelected ? colors.warning : colors.textPrimary,
                    size: 46,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: userRating == 0 || isSubmitting
                  ? null
                  : onSubmitRating,
              icon: Icon(
                isSubmitting
                    ? Icons.hourglass_top_rounded
                    : Icons.send_rounded,
              ),
              label: Text(
                isSubmitting ? l10n.saving : l10n.sendRating,
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}