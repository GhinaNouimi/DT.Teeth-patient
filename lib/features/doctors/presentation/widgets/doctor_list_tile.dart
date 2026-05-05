import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../models/doctor_ui_model.dart';

class DoctorListTile extends StatelessWidget {
  final DoctorUiModel doctor;
  final VoidCallback onTap;

  const DoctorListTile({
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
        child: Column(
          children: [
            Row(
              children: [
                /// صورة الطبيب
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
                      Row(
                        children: [
                          _MiniMeta(text: '${doctor.yearsOfExperience} سنوات'),
                          const SizedBox(width: 8),
                          _MiniMeta(text: '${doctor.treatedPatients}+ مريض'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: colors.buttonPrimary,
                ),
              ],
            ),
            /// التقييمات
            const SizedBox(height: 10),
            Row(
              children: [
                /// النجوم
                ...List.generate(5, (index) {
                  final isFilled = index < doctor.rating.toInt();
                  return Icon(
                    isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isFilled ? const Color(0xFFFFC107) : colors.borderSoft,
                    size: 16,
                  );
                }),
                const SizedBox(width: 6),
                Text(
                  '${doctor.rating}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${doctor.reviewsCount} تقييم)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniMeta extends StatelessWidget {
  final String text;

  const _MiniMeta({
    required this.text,
  });

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