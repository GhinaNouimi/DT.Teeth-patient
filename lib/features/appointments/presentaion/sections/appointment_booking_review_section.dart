import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/appointment_entity.dart';
import '../bloc/appointment_booking/appointment_booking_state.dart';

class AppointmentBookingReviewSection
    extends StatelessWidget {
  final AppointmentBookingLoaded state;
  final String languageCode;
  final String? notes;

  final VoidCallback onEditBookingType;
  final VoidCallback? onEditTreatment;
  final VoidCallback onEditNotes;
  final VoidCallback onEditAppointmentType;
  final VoidCallback onEditDentist;
  final VoidCallback onEditSchedule;

  const AppointmentBookingReviewSection({
    super.key,
    required this.state,
    required this.languageCode,
    required this.notes,
    required this.onEditBookingType,
    required this.onEditTreatment,
    required this.onEditNotes,
    required this.onEditAppointmentType,
    required this.onEditDentist,
    required this.onEditSchedule,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = context.colors;

    final appointmentTime =
        state.selectedAppointmentTime;

    final selectedTreatment =
        state.selectedTreatment;

    final dateLocale =
    languageCode == 'ar'
        ? 'ar_SA'
        : 'en_US';

    final formattedDate =
    appointmentTime == null
        ? '—'
        : DateFormat(
      'EEEE، d MMMM yyyy',
      dateLocale,
    ).format(
      appointmentTime,
    );

    final formattedTime =
    appointmentTime == null
        ? '—'
        : DateFormat(
      'hh:mm a',
      dateLocale,
    ).format(
      appointmentTime,
    );

    final normalizedNotes =
    notes?.trim();

    final displayedNotes =
    normalizedNotes == null ||
        normalizedNotes.isEmpty
        ? l10n.noAppointmentNotes
        : normalizedNotes;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          l10n.reviewAppointmentRequestTitle,
          style: theme
              .textTheme
              .titleLarge
              ?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          l10n.reviewAppointmentRequestDescription,
          style: theme
              .textTheme
              .bodyMedium
              ?.copyWith(
            color: colors.textSecondary,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 20),

        _ReviewCard(
          icon: Icons.category_outlined,
          title:
          l10n.bookingTypeReviewLabel,
          value: _bookingTypeLabel(
            context,
            state.selectedBookingType,
          ),
          onEdit: onEditBookingType,
        ),

        if (state.isContinueTreatmentBooking &&
            selectedTreatment != null) ...[
          const SizedBox(height: 12),

          _ReviewCard(
            icon:
            Icons.medical_services_outlined,
            title:
            l10n.treatmentReviewLabel,
            value: selectedTreatment
                .localizedTreatmentType(
              languageCode,
            ),
            subtitle:
            selectedTreatment.dentistName,
            onEdit:
            onEditTreatment,
          ),
        ],

        const SizedBox(height: 12),

        _ReviewCard(
          icon:
          Icons.event_note_outlined,
          title:
          l10n.appointmentTypeReviewLabel,
          value: state.selectedAppointmentType
              ?.localizedName(
            languageCode,
          ) ??
              '—',
          onEdit:
          onEditAppointmentType,
        ),

        const SizedBox(height: 12),

        _ReviewCard(
          icon:
          Icons.medical_information_outlined,
          title:
          l10n.dentistReviewLabel,
          value:
          state.selectedDentistName ??
              '—',

          // في متابعة العلاج الطبيب
          // مرتبط بالعلاج نفسه،
          // لذلك لا نسمح بتعديله.
          onEdit:
          state.isContinueTreatmentBooking
              ? null
              : onEditDentist,
        ),

        const SizedBox(height: 12),

        _ReviewCard(
          icon:
          Icons.calendar_month_outlined,
          title:
          l10n.appointmentDateReviewLabel,
          value:
          formattedDate,
          subtitle:
          formattedTime,
          onEdit:
          onEditSchedule,
        ),

        const SizedBox(height: 12),

        _ReviewCard(
          icon:
          Icons.notes_rounded,
          title:
          l10n.notesReviewLabel,
          value:
          displayedNotes,
          onEdit:
          onEditNotes,
        ),

        const SizedBox(height: 20),

        Container(
          width:
          double.infinity,
          padding:
          const EdgeInsets.all(
            16,
          ),
          decoration:
          BoxDecoration(
            color:
            colors.surfaceMuted,
            borderRadius:
            BorderRadius.circular(
              18,
            ),
            border:
            Border.all(
              color:
              colors.borderSoft,
            ),
          ),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Icon(
                Icons
                    .info_outline_rounded,
                color:
                colors.buttonPrimary,
                size:
                22,
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Text(
                  l10n
                      .appointmentRequestPendingNotice,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                    colors.textSecondary,
                    height:
                    1.55,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _bookingTypeLabel(
      BuildContext context,
      AppointmentBookingType? type,
      ) {
    final l10n =
        context.l10n;

    if (type ==
        AppointmentBookingType
            .newTreatment) {
      return l10n
          .newTreatmentBookingTitle;
    }

    if (type ==
        AppointmentBookingType
            .continueTreatment) {
      return l10n
          .continueTreatmentBookingTitle;
    }

    if (type ==
        AppointmentBookingType
            .emergency) {
      return l10n
          .emergencyBookingTitle;
    }

    if (type ==
        AppointmentBookingType
            .walkIn) {
      return l10n
          .walkInBookingTitle;
    }

    return '—';
  }
}

class _ReviewCard
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final VoidCallback? onEdit;

  const _ReviewCard({
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    this.onEdit,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colors =
        context.colors;

    return Container(
      width:
      double.infinity,
      padding:
      const EdgeInsets.all(
        16,
      ),
      decoration:
      BoxDecoration(
        color:
        colors.surfacePrimary,
        borderRadius:
        BorderRadius.circular(
          18,
        ),
        border:
        Border.all(
          color:
          colors.borderSoft,
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width:
            44,
            height:
            44,
            decoration:
            BoxDecoration(
              color:
              colors.buttonPrimary
                  .withValues(
                alpha:
                0.10,
              ),
              borderRadius:
              BorderRadius.circular(
                14,
              ),
            ),
            child: Icon(
              icon,
              color:
              colors.buttonPrimary,
              size:
              23,
            ),
          ),

          const SizedBox(
            width: 13,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                    colors.textSecondary,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  value,
                  style: theme
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                    color:
                    colors.textPrimary,
                    fontWeight:
                    FontWeight.w800,
                    height:
                    1.4,
                  ),
                ),

                if (subtitle != null &&
                    subtitle!
                        .trim()
                        .isNotEmpty) ...[
                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    subtitle!,
                    style: theme
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color:
                      colors.textSecondary,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (onEdit != null) ...[
            const SizedBox(
              width: 8,
            ),

            IconButton(
              onPressed:
              onEdit,
              tooltip:
              context.l10n.editButton,
              icon: Icon(
                Icons.edit_outlined,
                color:
                colors.buttonPrimary,
                size:
                21,
              ),
            ),
          ],
        ],
      ),
    );
  }
}