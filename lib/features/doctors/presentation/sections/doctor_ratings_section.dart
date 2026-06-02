import 'package:flutter/material.dart';

import '../../../../core/theme/app_color_tokens.dart';
import '../models/doctor_ui_model.dart';
import '../widgets/doctor_section_title.dart';

class DoctorRatingsSection extends StatelessWidget {
  final DoctorUiModel doctor;
  final double userRating;
  final ValueChanged<double> onRatingChanged;
  final VoidCallback onSubmitRating;
  final AppColorTokens colors;
  final ThemeData theme;

  const DoctorRatingsSection({
    super.key,
    required this.doctor,
    required this.userRating,
    required this.onRatingChanged,
    required this.onSubmitRating,
    required this.colors,
    required this.theme,
  });

  String _getRatingText(int rating) {
    switch (rating) {
      case 5:
        return 'ممتاز جداً! 😍';
      case 4:
        return 'جيد جداً! 😊';
      case 3:
        return 'جيد 👍';
      case 2:
        return 'حسن 👌';
      case 1:
        return 'لم يعجبني 😞';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoctorSectionTitle(title: 'التقييمات', theme: theme, colors: colors),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${doctor.rating}',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(5, (index) {
                  final isFilled = index < doctor.rating.toInt();
                  return Icon(
                    isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isFilled
                        ? const Color(0xFFFFC107)
                        : colors.textPrimary,
                    size: 16,
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                '${doctor.reviewsCount} تقييم',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            'قيّم الطبيب',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () => onRatingChanged((index + 1).toDouble()),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          index < userRating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: index < userRating
                              ? const Color(0xFFFFC107)
                              : colors.textPrimary,
                          size: 40,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                if (userRating > 0)
                  Text(
                    _getRatingText(userRating.toInt()),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                const SizedBox(height: 16),
                if (userRating > 0)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onSubmitRating,
                      icon: const Icon(Icons.send_rounded),
                      label: const Text('إرسال التقييم'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
