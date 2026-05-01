import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import 'appointment_details_card.dart';

class AppointmentDoctorCard extends StatelessWidget {
  const AppointmentDoctorCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return AppointmentDetailCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: colors.surfaceMuted,
            child: Icon(
              Icons.person_rounded,
              color: colors.navBarItem,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'د. سارة جابر',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'طبيبة أسنان عامة',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'غرفة B3',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
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
