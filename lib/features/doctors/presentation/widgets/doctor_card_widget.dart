import 'package:dt_teeth/features/doctors/presentation/models/doctor_ui_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/theme_extensions.dart';

class DoctorCardWidget extends StatelessWidget {
  final DoctorUiModel doctor;
  final VoidCallback onTap;

  const DoctorCardWidget({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surfacePrimary,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colors.borderSoft),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: colors.surfaceMuted,
              child: Text(
                doctor.imageUrl,
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialty,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _MiniMetaWidget(
                        text: '${doctor.yearsOfExperience} سنوات',
                      ),
                      _MiniMetaWidget(text: '${doctor.treatedPatients}+ مريض'),
                    ],
                  ),
                ],
              ),
            ),
            _RatingBadgeWidget(
              rating: doctor.rating,
              reviewsCount: doctor.reviewsCount,
              colors: colors,
              theme: theme,
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: colors.buttonPrimary,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniMetaWidget extends StatelessWidget {
  final String text;

  const _MiniMetaWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RatingBadgeWidget extends StatelessWidget {
  final double rating;
  final int reviewsCount;
  final dynamic colors;
  final ThemeData theme;

  const _RatingBadgeWidget({
    required this.rating,
    required this.reviewsCount,
    required this.colors,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(5, (index) {
                final isFilled = index < rating.toInt();
                return Icon(
                  isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: isFilled ? const Color(0xFFFFC107) : colors.borderSoft,
                  size: 14,
                );
              }),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '$rating',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          Text(
            '($reviewsCount)',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
