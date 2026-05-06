import 'package:dt_teeth/features/doctors/presentation/models/doctor_ui_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class DoctorProfileHeaderSection extends StatelessWidget {
  final DoctorUiModel doctor;

  const DoctorProfileHeaderSection({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Column(
      children: [
        // صورة الطبيب بحجم كبير مثل المثال
        Center(
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: colors.surfaceSecondary,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: colors.buttonPrimary,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.buttonPrimary.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Text(
                doctor.imageUrl,
                style: const TextStyle(fontSize: 80),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // الاسم والاختصاص
        Center(
          child: Column(
            children: [
              Text(
                doctor.name,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                doctor.specialty,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              // التقييم
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(5, (index) {
                      final isFilled = index < doctor.rating.toInt();
                      return Icon(
                        isFilled
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: isFilled
                            ? const Color(0xFFFFC107)
                            : colors.borderSoft,
                        size: 18,
                      );
                    }),
                    const SizedBox(width: 8),
                    Text(
                      '${doctor.rating} (${doctor.reviewsCount})',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}