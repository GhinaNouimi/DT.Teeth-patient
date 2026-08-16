import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/feedback/offline_cached_banner.dart';
import '../../../domain/entities/appointment_entity.dart';

class AppointmentDetailsContent extends StatelessWidget {
  final AppointmentEntity appointment;
  final bool isFromCache;
  final bool isCancelling;
  final bool showOfflineBanner;

  final VoidCallback onCloseOfflineBanner;
  final Future<void> Function() onRefresh;

  final ValueChanged<AppointmentEntity>
  onRescheduleAppointment;

  final ValueChanged<AppointmentEntity>
  onCancelAppointment;

  const AppointmentDetailsContent({
    super.key,
    required this.appointment,
    required this.isFromCache,
    required this.isCancelling,
    required this.showOfflineBanner,
    required this.onCloseOfflineBanner,
    required this.onRefresh,
    required this.onRescheduleAppointment,
    required this.onCancelAppointment,
  });

  @override
  Widget build(BuildContext context) {
    final languageCode =
        Localizations.localeOf(context).languageCode;

    final localeName =
    languageCode.toLowerCase().startsWith('ar')
        ? 'ar'
        : 'en';

    final formattedDate = intl.DateFormat(
      'EEEE، d MMMM y',
      localeName,
    ).format(
      appointment.appointmentTime,
    );

    final formattedTime = intl.DateFormat(
      'hh:mm a',
      localeName,
    ).format(
      appointment.appointmentTime,
    );

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(
          20,
          18,
          20,
          32,
        ),
        children: [
          if (isFromCache &&
              showOfflineBanner) ...[
            OfflineCachedBanner(
              message: context
                  .l10n
                  .appointmentDetailsOfflineMessage,
              onClose: onCloseOfflineBanner,
            ),
            const SizedBox(height: 20),
          ],

          _StatusSection(
            status: appointment.status,
          ),

          const SizedBox(height: 22),
          const _SectionDivider(),
          const SizedBox(height: 22),

          _SectionTitle(
            title: context
                .l10n
                .appointmentInformationTitle,
          ),

          const SizedBox(height: 16),

          _InfoRow(
            icon: Icons.calendar_today_rounded,
            title: context
                .l10n
                .appointmentDateLabel,
            value: formattedDate,
          ),

          const SizedBox(height: 16),

          _InfoRow(
            icon: Icons.access_time_rounded,
            title: context
                .l10n
                .appointmentTimeLabel,
            value: formattedTime,
          ),

          const SizedBox(height: 16),

          _InfoRow(
            icon: Icons.medical_services_outlined,
            title: context
                .l10n
                .appointmentTypeLabel,
            value:
            appointment
                .localizedAppointmentType(
              languageCode,
            ),
          ),

          const SizedBox(height: 22),
          const _SectionDivider(),
          const SizedBox(height: 22),

          _SectionTitle(
            title: context.l10n.dentistTitle,
          ),

          const SizedBox(height: 14),

          _DentistCard(
            dentistName:
            appointment.dentistName,
            dentistPhoto:
            appointment.dentistPhoto,
          ),

          if (appointment.hasTreatment) ...[
            const SizedBox(height: 22),
            const _SectionDivider(),
            const SizedBox(height: 22),

            _TreatmentSection(
              treatment:
              appointment.treatment!,
              languageCode:
              languageCode,
            ),
          ],

          if (appointment.hasNotes) ...[
            const SizedBox(height: 22),
            const _SectionDivider(),
            const SizedBox(height: 22),

            _NotesSection(
              title: context
                  .l10n
                  .appointmentNotesTitle,
              notes:
              appointment.notes!,
            ),
          ],

          if (appointment
              .hasRejectionReason) ...[
            const SizedBox(height: 22),
            const _SectionDivider(),
            const SizedBox(height: 22),

            _RejectionReasonSection(
              reason:
              appointment
                  .rejectionReason!,
            ),
          ],

          if (appointment
              .canAttemptReschedule ||
              appointment
                  .canAttemptCancellation) ...[
            const SizedBox(height: 28),

            _AppointmentActions(
              appointment:
              appointment,
              isFromCache:
              isFromCache,
              isCancelling:
              isCancelling,
              onReschedule: () {
                onRescheduleAppointment(
                  appointment,
                );
              },
              onCancel: () {
                onCancelAppointment(
                  appointment,
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusSection
    extends StatelessWidget {
  final AppointmentStatus status;

  const _StatusSection({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final statusPresentation =
    _appointmentStatusPresentation(
      context,
      status,
    );

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title:
          context
              .l10n
              .appointmentStatusTitle,
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding:
          const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color:
            statusPresentation.color
                .withValues(
              alpha: 0.12,
            ),
            borderRadius:
            BorderRadius.circular(16),
            border: Border.all(
              color:
              statusPresentation.color
                  .withValues(
                alpha: 0.25,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                statusPresentation.icon,
                color:
                statusPresentation.color,
                size: 21,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  statusPresentation.label,
                  style:
                  Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                    color:
                    statusPresentation
                        .color,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DentistCard
    extends StatelessWidget {
  final String dentistName;
  final String? dentistPhoto;

  const _DentistCard({
    required this.dentistName,
    this.dentistPhoto,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        context.colors;
    final theme =
    Theme.of(context);

    final normalizedPhoto =
    dentistPhoto?.trim();

    final hasPhoto =
        normalizedPhoto != null &&
            normalizedPhoto.isNotEmpty;

    return Container(
      padding:
      const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
        colors.surfaceMuted,
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color:
          colors.borderSoft,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor:
            colors.surfaceSecondary,
            child: ClipOval(
              child: hasPhoto
                  ? CachedNetworkImage(
                imageUrl:
                normalizedPhoto,
                width: 54,
                height: 54,
                fit: BoxFit.cover,
                placeholder: (
                    context,
                    imageUrl,
                    ) {
                  return SizedBox(
                    width: 54,
                    height: 54,
                    child: Center(
                      child:
                      CircularProgressIndicator(
                        strokeWidth:
                        2,
                        color:
                        colors
                            .buttonPrimary,
                      ),
                    ),
                  );
                },
                errorWidget: (
                    context,
                    imageUrl,
                    error,
                    ) {
                  return SizedBox(
                    width: 54,
                    height: 54,
                    child: Icon(
                      Icons
                          .person_rounded,
                      color:
                      colors
                          .buttonPrimary,
                      size: 28,
                    ),
                  );
                },
              )
                  : SizedBox(
                width: 54,
                height: 54,
                child: Icon(
                  Icons
                      .person_rounded,
                  color:
                  colors
                      .buttonPrimary,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              dentistName,
              style:
              theme
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                color:
                colors
                    .textPrimary,
                fontWeight:
                FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TreatmentSection
    extends StatelessWidget {
  final AppointmentTreatmentEntity
  treatment;

  final String languageCode;

  const _TreatmentSection({
    required this.treatment,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final l10n =
        context.l10n;
    final colors =
        context.colors;
    final theme =
    Theme.of(context);

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title:
          l10n
              .treatmentInformationTitle,
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding:
          const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color:
            colors
                .surfaceSecondary,
            borderRadius:
            BorderRadius.circular(20),
            border: Border.all(
              color:
              colors.borderSoft,
            ),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                treatment
                    .localizedTreatmentType(
                  languageCode,
                ),
                style:
                theme
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  color:
                  colors
                      .textPrimary,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),

              _TreatmentDataRow(
                title:
                l10n
                    .treatmentStatusLabel,
                value:
                _localizedTreatmentStatus(
                  context,
                  treatment.status,
                ),
              ),

              const SizedBox(height: 10),

              _TreatmentDataRow(
                title:
                l10n
                    .completedSessionsLabel,
                value:
                '${treatment.sessionsCompleted} / '
                    '${treatment.totalSessionsNeeded}',
              ),

              if (treatment
                  .totalSessionsNeeded >
                  0) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),
                  child:
                  LinearProgressIndicator(
                    value:
                    treatment.progress,
                    minHeight: 9,
                    backgroundColor:
                    colors
                        .surfaceMuted,
                  ),
                ),
              ],

              if (treatment.hasNotes) ...[
                const SizedBox(height: 16),
                Text(
                  treatment.notes!,
                  style:
                  theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color:
                    colors
                        .textSecondary,
                    height: 1.6,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TreatmentDataRow
    extends StatelessWidget {
  final String title;
  final String value;

  const _TreatmentDataRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        context.colors;
    final theme =
    Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style:
            theme
                .textTheme
                .bodyMedium
                ?.copyWith(
              color:
              colors
                  .textSecondary,
              fontWeight:
              FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style:
          theme
              .textTheme
              .bodyMedium
              ?.copyWith(
            color:
            colors
                .textPrimary,
            fontWeight:
            FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _NotesSection
    extends StatelessWidget {
  final String title;
  final String notes;

  const _NotesSection({
    required this.title,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        context.colors;
    final theme =
    Theme.of(context);

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: title,
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding:
          const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color:
            colors
                .surfaceSecondary,
            borderRadius:
            BorderRadius.circular(20),
          ),
          child: Text(
            notes,
            style:
            theme
                .textTheme
                .bodyMedium
                ?.copyWith(
              color:
              colors
                  .textPrimary,
              height: 1.7,
              fontWeight:
              FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _RejectionReasonSection
    extends StatelessWidget {
  final String reason;

  const _RejectionReasonSection({
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
    Theme.of(context);

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title:
          context
              .l10n
              .rejectionReasonTitle,
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding:
          const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color:
            theme
                .colorScheme
                .error
                .withValues(
              alpha: 0.08,
            ),
            borderRadius:
            BorderRadius.circular(20),
            border: Border.all(
              color:
              theme
                  .colorScheme
                  .error
                  .withValues(
                alpha: 0.20,
              ),
            ),
          ),
          child: Text(
            reason,
            style:
            theme
                .textTheme
                .bodyMedium
                ?.copyWith(
              color:
              theme
                  .colorScheme
                  .error,
              height: 1.7,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _AppointmentActions
    extends StatelessWidget {
  final AppointmentEntity appointment;
  final bool isFromCache;
  final bool isCancelling;

  final VoidCallback onReschedule;
  final VoidCallback onCancel;

  const _AppointmentActions({
    required this.appointment,
    required this.isFromCache,
    required this.isCancelling,
    required this.onReschedule,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
    Theme.of(context);
    final colors =
        context.colors;

    return Column(
      children: [
        Row(
          children: [
            if (appointment
                .canAttemptReschedule)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                  isFromCache
                      ? null
                      : onReschedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    colors.buttonPrimary,
                    foregroundColor:
                    colors.textPrimary,
                    disabledBackgroundColor:
                    colors.buttonPrimary.withValues(
                      alpha: 0.35,
                    ),
                    disabledForegroundColor:
                    Colors.white.withValues(
                      alpha: 0.80,
                    ),
                    elevation: 0,
                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(
                    Icons.edit_calendar_rounded,
                    size: 19,
                  ),
                  label: Text(
                    context.l10n.editAppointmentTitle,
                  ),
                ),
              ),

            if (appointment
                .canAttemptReschedule &&
                appointment
                    .canAttemptCancellation)
              const SizedBox(width: 12),

            if (appointment
                .canAttemptCancellation)
              Expanded(
                child:
                ElevatedButton.icon(
                  onPressed:
                  isCancelling ||
                      isFromCache
                      ? null
                      : onCancel,
                  style:
                  ElevatedButton
                      .styleFrom(
                    backgroundColor:
                    theme
                        .colorScheme
                        .error,
                    foregroundColor:
                    theme
                        .colorScheme
                        .onError,
                    disabledBackgroundColor:
                    theme
                        .colorScheme
                        .error
                        .withValues(
                      alpha: 0.35,
                    ),
                    disabledForegroundColor:
                    theme
                        .colorScheme
                        .onError
                        .withValues(
                      alpha: 0.75,
                    ),
                    elevation: 0,
                    padding:
                    const EdgeInsets
                        .symmetric(
                      vertical: 15,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),
                  icon: isCancelling
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color:
                      Colors.white,
                    ),
                  )
                      : const Icon(
                    Icons
                        .close_rounded,
                    size: 19,
                  ),
                  label: Text(
                    isCancelling
                        ? context
                        .l10n
                        .cancellingAppointmentButton
                        : context
                        .l10n
                        .cancelAppointmentButton,
                  ),
                ),
              ),
          ],
        ),

        if (isFromCache) ...[
          const SizedBox(height: 10),
          Text(
            context
                .l10n
                .offlineCancellationUnavailableMessage,
            textAlign:
            TextAlign.center,
            style:
            theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color:
              colors
                  .textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoRow
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
    Theme.of(context);
    final colors =
        context.colors;

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color:
            colors
                .surfaceMuted,
            borderRadius:
            BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 20,
            color:
            colors
                .buttonPrimary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color:
                  colors
                      .textSecondary,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style:
                theme
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                  color:
                  colors
                      .textPrimary,
                  fontWeight:
                  FontWeight.w700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle
    extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
    Theme.of(context);
    final colors =
        context.colors;

    return Text(
      title,
      style:
      theme
          .textTheme
          .titleMedium
          ?.copyWith(
        color:
        colors
            .textPrimary,
        fontWeight:
        FontWeight.w800,
      ),
    );
  }
}

class _SectionDivider
    extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      color:
      context
          .colors
          .borderSoft,
      height: 1,
    );
  }
}

class _StatusPresentation {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusPresentation({
    required this.label,
    required this.color,
    required this.icon,
  });
}

_StatusPresentation
_appointmentStatusPresentation(
    BuildContext context,
    AppointmentStatus status,
    ) {
  final l10n =
      context.l10n;
  final theme =
  Theme.of(context);

  switch (status) {
    case AppointmentStatus.pending:
      return _StatusPresentation(
        label:
        l10n
            .appointmentStatusPending,
        color:
        Colors.orange,
        icon:
        Icons.schedule_rounded,
      );

    case AppointmentStatus
        .pendingSecretary:
      return _StatusPresentation(
        label:
        l10n
            .appointmentStatusPendingSecretary,
        color:
        Colors.orange,
        icon:
        Icons
            .hourglass_top_rounded,
      );

    case AppointmentStatus.approved:
      return _StatusPresentation(
        label:
        l10n
            .appointmentStatusApproved,
        color:
        Colors.green,
        icon:
        Icons
            .check_circle_outline_rounded,
      );

    case AppointmentStatus.rejected:
      return _StatusPresentation(
        label:
        l10n
            .appointmentStatusRejected,
        color:
        theme
            .colorScheme
            .error,
        icon:
        Icons.cancel_outlined,
      );

    case AppointmentStatus.cancelled:
      return _StatusPresentation(
        label:
        l10n
            .appointmentStatusCancelled,
        color:
        theme
            .colorScheme
            .error,
        icon:
        Icons.event_busy_rounded,
      );

    case AppointmentStatus.completed:
      return _StatusPresentation(
        label:
        l10n
            .appointmentStatusCompleted,
        color:
        Colors.blue,
        icon:
        Icons.task_alt_rounded,
      );

    case AppointmentStatus
        .patientNoShow:
      return _StatusPresentation(
        label:
        l10n
            .appointmentStatusPatientNoShow,
        color:
        Colors.deepOrange,
        icon:
        Icons
            .person_off_outlined,
      );

    case AppointmentStatus.unknown:
      return _StatusPresentation(
        label:
        l10n
            .appointmentStatusUnknown,
        color:
        Colors.grey,
        icon:
        Icons
            .help_outline_rounded,
      );
  }
}

String _localizedTreatmentStatus(
    BuildContext context,
    String status,
    ) {
  switch (
  status.trim().toLowerCase()) {
    case 'ongoing':
      return context
          .l10n
          .treatmentStatusOngoing;

    case 'completed':
      return context
          .l10n
          .treatmentStatusCompleted;

    case 'cancelled':
      return context
          .l10n
          .treatmentStatusCancelled;

    default:
      return status;
  }
}