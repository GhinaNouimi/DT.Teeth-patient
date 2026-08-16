import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../domain/entities/appointment_entity.dart';

class CurrentAppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final String languageCode;

  const CurrentAppointmentCard({
    super.key,
    required this.appointment,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    final locale =
    languageCode.toLowerCase().startsWith('ar')
        ? 'ar_SA'
        : 'en_US';

    final formattedDate = DateFormat(
      'EEEE، d MMMM yyyy',
      locale,
    ).format(
      appointment.appointmentTime,
    );

    final formattedTime = DateFormat(
      'hh:mm a',
      locale,
    ).format(
      appointment.appointmentTime,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.buttonPrimary.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.event_note_rounded,
                  color: colors.buttonPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.l10n.currentAppointmentTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          _InfoRow(
            icon: Icons.medical_information_outlined,
            label: context.l10n.dentistReviewLabel,
            value: appointment.dentistName,
          ),

          const SizedBox(height: 12),

          _InfoRow(
            icon: Icons.category_outlined,
            label: context.l10n.appointmentTypeReviewLabel,
            value: appointment.localizedAppointmentType(
              languageCode,
            ),
          ),

          const SizedBox(height: 12),

          _InfoRow(
            icon: Icons.calendar_month_outlined,
            label: context.l10n.appointmentDateReviewLabel,
            value: formattedDate,
          ),

          const SizedBox(height: 12),

          _InfoRow(
            icon: Icons.access_time_rounded,
            label: context.l10n.appointmentTimeLabel,
            value: formattedTime,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 19,
          color: colors.textSecondary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}