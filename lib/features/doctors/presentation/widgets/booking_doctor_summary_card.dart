import 'package:flutter/material.dart';

import '../../../../core/theme/app_color_tokens.dart';
import '../models/doctor_ui_model.dart';

class BookingDoctorSummaryCard extends StatelessWidget {
  final DoctorUiModel doctor;
  final AppColorTokens colors;
  final ThemeData theme;
  final bool highlighted;

  const BookingDoctorSummaryCard({
    super.key,
    required this.doctor,
    required this.colors,
    required this.theme,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlighted ? colors.surfaceSecondary : colors.surfacePrimary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: colors.surfaceMuted,
            child: Text(doctor.imageUrl, style: const TextStyle(fontSize: 36)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.specialty,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '⭐ ${doctor.rating} (${doctor.reviewsCount})',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
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
