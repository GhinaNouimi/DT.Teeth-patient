import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../models/doctor_ui_model.dart';
import '../widgets/doctor_profile_stat_chip.dart';

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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 52,
            backgroundColor: colors.surfaceMuted,
            child: Icon(
              Icons.person_rounded,
              size: 54,
              color: colors.navBarItem,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            doctor.name,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            doctor.specialty,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              DoctorProfileStatChip(
                label: '${doctor.yearsOfExperience} سنوات خبرة',
              ),
              DoctorProfileStatChip(
                label: '${doctor.treatedPatients}+ مريض',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
