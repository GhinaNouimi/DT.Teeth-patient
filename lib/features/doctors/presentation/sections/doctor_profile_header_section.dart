import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/dentist_details_entity.dart';

class DoctorProfileHeaderSection extends StatelessWidget {
  final DentistDetailsEntity dentist;
  final String languageCode;

  const DoctorProfileHeaderSection({
    super.key,
    required this.dentist,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    final specialization = languageCode == 'en'
        ? dentist.specializationEn
        : dentist.specializationAr;

    final rating = double.tryParse(dentist.averageRating) ?? 0;

    return Column(
      children: [
        Center(
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: colors.surfaceSecondary,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: colors.buttonPrimary, width: 3),
              boxShadow: [
                BoxShadow(
                  color: colors.buttonPrimary.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: dentist.profilePicture != null &&
                dentist.profilePicture!.trim().isNotEmpty
                ? Image.network(
              dentist.profilePicture!,
              fit: BoxFit.cover,
            )
                : Icon(
              Icons.person_rounded,
              size: 80,
              color: colors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          dentist.name,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          specialization,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
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
                final isFilled = index < rating.round();

                return Icon(
                  isFilled
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: isFilled ? colors.warning : colors.borderSoft,
                  size: 18,
                );
              }),
              const SizedBox(width: 8),
              Text(
                dentist.averageRating,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}