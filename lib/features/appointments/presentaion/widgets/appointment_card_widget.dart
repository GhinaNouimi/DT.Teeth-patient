import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/common/app_section_card.dart';
import '../../../../core/widgets/common/app_status_chip.dart';
import '../models/appointment_status.dart';
import '../models/appointment_type.dart';
import '../models/appointment_ui_model.dart';

class AppointmentCardWidget extends StatelessWidget {
  final AppointmentUiModel appointment;
  final VoidCallback onTap;
  final bool isUpcoming;

  const AppointmentCardWidget({
    super.key,
    required this.appointment,
    required this.onTap,
    required this.isUpcoming,
  });

  AppStatusType _statusType(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.confirmed:
      case AppointmentStatus.completed:
        return AppStatusType.success;
      case AppointmentStatus.pending:
        return AppStatusType.warning;
      case AppointmentStatus.cancelled:
        return AppStatusType.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return AppSectionCard(
      onTap: onTap,
      radius: AppRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: colors.surfaceMuted,
            child: Text(
              appointment.doctor.imageUrl,
              style: const TextStyle(fontSize: 32),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppStatusChip(
                  label: appointment.status.displayName,
                  type: _statusType(appointment.status),
                  isCompact: true,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  appointment.doctor.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  appointment.service.displayName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                /// التاريخ والوقت
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.xs,
                  children: [
                    _AppointmentMetaItem(
                      icon: Icons.calendar_today_rounded,
                      text: DateFormat(
                        'd MMM',
                        'ar_SA',
                      ).format(appointment.appointmentDate),
                    ),
                    _AppointmentMetaItem(
                      icon: Icons.schedule_rounded,
                      text: appointment.appointmentTime,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          appointment.type == AppointmentType.emergency
              ? AppStatusChip(
            label: 'طارئ',
            type: AppStatusType.error,
            icon: Icons.priority_high_rounded,
            isCompact: true,
          )
              : Icon(
            Icons.arrow_forward_ios_rounded,
            color: colors.buttonPrimary,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class _AppointmentMetaItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _AppointmentMetaItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: colors.buttonPrimary,
          size: 14,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}