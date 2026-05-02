import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../models/doctor_ui_model.dart';
import '../widgets/doctor_contact_tile.dart';

class DoctorProfileContactSection extends StatelessWidget {
  final DoctorUiModel doctor;

  const DoctorProfileContactSection({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'التواصل والحسابات',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          DoctorContactTile(
            icon: Icons.call_outlined,
            label: doctor.phone,
          ),
          const SizedBox(height: 10),
          DoctorContactTile(
            icon: Icons.email_outlined,
            label: doctor.email,
          ),
          const SizedBox(height: 10),
          DoctorContactTile(
            icon: Icons.camera_alt_outlined,
            label: doctor.instagram,
          ),
          const SizedBox(height: 10),
          DoctorContactTile(
            icon: Icons.work_outline_rounded,
            label: doctor.linkedin,
          ),
        ],
      ),
    );
  }
}
