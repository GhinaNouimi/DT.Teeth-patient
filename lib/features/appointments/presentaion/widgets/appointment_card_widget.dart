import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/common/app_section_card.dart';
import '../../../../core/widgets/common/app_status_chip.dart';
import '../../domain/entities/appointment_entity.dart';

class AppointmentCardWidget extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback? onTap;
  final bool isCancelling;

  const AppointmentCardWidget({
    super.key,
    required this.appointment,
    required this.onTap,
    this.isCancelling = false,
  });

  AppStatusType _statusType(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.approved:
      case AppointmentStatus.completed:
        return AppStatusType.success;

      case AppointmentStatus.pending:
      case AppointmentStatus.pendingSecretary:
      case AppointmentStatus.unknown:
        return AppStatusType.warning;

      case AppointmentStatus.rejected:
      case AppointmentStatus.cancelled:
      case AppointmentStatus.patientNoShow:
        return AppStatusType.error;
    }
  }

  String _localizedStatus(
      BuildContext context,
      AppointmentStatus status,
      ) {
    final l10n = context.l10n;

    switch (status) {
      case AppointmentStatus.pending:
        return l10n.appointmentPending;

      case AppointmentStatus.pendingSecretary:
        return l10n.appointmentPendingSecretary;

      case AppointmentStatus.approved:
        return l10n.appointmentApproved;

      case AppointmentStatus.rejected:
        return l10n.appointmentRejected;

      case AppointmentStatus.cancelled:
        return l10n.appointmentCancelled;

      case AppointmentStatus.completed:
        return l10n.appointmentCompleted;

      case AppointmentStatus.patientNoShow:
        return l10n.appointmentPatientNoShow;

      case AppointmentStatus.unknown:
        return l10n.unknownStatus;
    }
  }

  String _localizedBookingType(
      BuildContext context,
      AppointmentBookingType type,
      ) {
    final l10n = context.l10n;

    switch (type) {
      case AppointmentBookingType.emergency:
        return l10n.emergencyAppointmentTitle;

      case AppointmentBookingType.newTreatment:
        return l10n.appointmentNewTreatment;

      case AppointmentBookingType.continueTreatment:
        return l10n.appointmentContinueTreatment;

      case AppointmentBookingType.walkIn:
        return l10n.appointmentWalkIn;

      case AppointmentBookingType.unknown:
        return l10n.unknownStatus;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    final locale =
    Localizations.localeOf(context).toLanguageTag();

    final languageCode =
        Localizations.localeOf(context).languageCode;

    final appointmentType =
    appointment.localizedAppointmentType(
      languageCode,
    );

    final treatmentName = appointment.treatment
        ?.localizedTreatmentType(languageCode);

    final formattedDate = intl.DateFormat(
      'd MMM yyyy',
      locale,
    ).format(appointment.appointmentTime);

    final formattedTime = intl.DateFormat(
      'h:mm a',
      locale,
    ).format(appointment.appointmentTime);

    final isRtl =
        Directionality.of(context) == TextDirection.rtl;

    return AnimatedOpacity(
      opacity: isCancelling ? 0.65 : 1,
      duration: const Duration(milliseconds: 200),
      child: AppSectionCard(
        onTap: isCancelling ? null : onTap,
        radius: AppRadius.lg,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: colors.surfaceMuted,
              child: Icon(
                appointment.type ==
                    AppointmentBookingType.emergency
                    ? Icons.emergency_rounded
                    : Icons.calendar_month_rounded,
                color: appointment.type ==
                    AppointmentBookingType.emergency
                    ? theme.colorScheme.error
                    : colors.buttonPrimary,
                size: 26,
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      AppStatusChip(
                        label: _localizedStatus(
                          context,
                          appointment.status,
                        ),
                        type: _statusType(
                          appointment.status,
                        ),
                        isCompact: true,
                      ),

                      if (appointment.type ==
                          AppointmentBookingType
                              .emergency)
                        AppStatusChip(
                          label: l10n.emergencyLabel,
                          type: AppStatusType.error,
                          icon:
                          Icons.priority_high_rounded,
                          isCompact: true,
                        ),

                      if (isCancelling)
                        AppStatusChip(
                          label:
                          l10n.cancellingAppointment,
                          type: AppStatusType.warning,
                          icon:
                          Icons.hourglass_top_rounded,
                          isCompact: true,
                        ),
                    ],
                  ),

                  const SizedBox(
                    height: AppSpacing.sm,
                  ),

                  Text(
                    appointment.dentistName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                    theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                    ),
                  ),

                  const SizedBox(
                    height: AppSpacing.xxs,
                  ),

                  Text(
                    appointmentType.isNotEmpty
                        ? appointmentType
                        : _localizedBookingType(
                      context,
                      appointment.type,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                    theme.textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),

                  if (treatmentName != null &&
                      treatmentName.trim().isNotEmpty) ...[
                    const SizedBox(
                      height: AppSpacing.xxs,
                    ),
                    Text(
                      treatmentName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                      theme.textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],

                  const SizedBox(
                    height: AppSpacing.sm,
                  ),

                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.xs,
                    children: [
                      _AppointmentMetaItem(
                        icon:
                        Icons.calendar_today_rounded,
                        text: formattedDate,
                      ),
                      _AppointmentMetaItem(
                        icon: Icons.schedule_rounded,
                        text: formattedTime,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            if (!isCancelling)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(
                  isRtl
                      ? Icons.arrow_back_ios_new_rounded
                      : Icons.arrow_forward_ios_rounded,
                  color: colors.buttonPrimary,
                  size: 16,
                ),
              ),
          ],
        ),
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