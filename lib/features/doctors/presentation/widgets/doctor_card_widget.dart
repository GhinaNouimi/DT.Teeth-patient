import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/common/app_section_card.dart';
import '../../domain/entities/dentist_entity.dart';

class DoctorCardWidget extends StatelessWidget {
  final DentistEntity dentist;
  final String languageCode;
  final VoidCallback onTap;

  const DoctorCardWidget({
    super.key,
    required this.dentist,
    required this.languageCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final specialization = languageCode == 'en'
        ? dentist.specializationNameEn
        : dentist.specializationName;

    return AppSectionCard(
      onTap: onTap,
      radius: AppRadius.xl,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: colors.surfaceMuted,
            backgroundImage: dentist.profilePicture != null &&
                dentist.profilePicture!.trim().isNotEmpty
                ? NetworkImage(dentist.profilePicture!)
                : null,
            child: dentist.profilePicture == null ||
                dentist.profilePicture!.trim().isEmpty
                ? Icon(
              Icons.person_rounded,
              size: 36,
              color: colors.textSecondary,
            )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dentist.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  specialization,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: colors.buttonPrimary,
          ),
        ],
      ),
    );
  }
}