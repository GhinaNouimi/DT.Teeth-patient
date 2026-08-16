import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../domain/entities/appointment_entity.dart';

class AppointmentEditReviewSheet
    extends StatelessWidget {
  final AppointmentEntity appointment;
  final DateTime newAppointmentTime;
  final String? notes;
  final String languageCode;
  final VoidCallback onConfirm;

  const AppointmentEditReviewSheet({
    super.key,
    required this.appointment,
    required this.newAppointmentTime,
    required this.notes,
    required this.languageCode,
    required this.onConfirm,
  });

  static Future<void> show(
      BuildContext context, {
        required AppointmentEntity appointment,
        required DateTime newAppointmentTime,
        required String? notes,
        required String languageCode,
        required VoidCallback onConfirm,
      }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return AppointmentEditReviewSheet(
          appointment: appointment,
          newAppointmentTime: newAppointmentTime,
          notes: notes,
          languageCode: languageCode,
          onConfirm: onConfirm,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    final actionColor =
        colors.buttonPrimary;

    final locale =
    languageCode
        .toLowerCase()
        .startsWith('ar')
        ? 'ar_SA'
        : 'en_US';

    final oldDate = DateFormat(
      'EEEE، d MMMM yyyy',
      locale,
    ).format(
      appointment.appointmentTime,
    );

    final oldTime = DateFormat(
      'hh:mm a',
      locale,
    ).format(
      appointment.appointmentTime,
    );

    final newDate = DateFormat(
      'EEEE، d MMMM yyyy',
      locale,
    ).format(
      newAppointmentTime,
    );

    final newTime = DateFormat(
      'hh:mm a',
      locale,
    ).format(
      newAppointmentTime,
    );

    final normalizedNotes =
    notes?.trim();

    return SafeArea(
      top: false,
      child: Container(
        padding:
        const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          24,
        ),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius:
          const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration:
                  BoxDecoration(
                    color:
                    colors.borderSoft,
                    borderRadius:
                    BorderRadius.circular(
                      99,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                context
                    .l10n
                    .reviewAppointmentEditTitle,
                style: theme
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                  color:
                  colors.textPrimary,
                  fontWeight:
                  FontWeight.w900,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                context
                    .l10n
                    .reviewAppointmentEditDescription,
                style: theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color:
                  colors.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              _DateComparisonCard(
                title: context
                    .l10n
                    .currentAppointmentTitle,
                date: oldDate,
                time: oldTime,
                emphasized: false,
                accentColor:
                actionColor,
              ),

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Center(
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration:
                    BoxDecoration(
                      color:
                      actionColor.withValues(
                        alpha: 0.08,
                      ),
                      shape:
                      BoxShape.circle,
                    ),
                    child: Icon(
                      Icons
                          .keyboard_arrow_down_rounded,
                      color:
                      actionColor,
                      size: 27,
                    ),
                  ),
                ),
              ),

              _DateComparisonCard(
                title: context
                    .l10n
                    .newAppointmentTitle,
                date: newDate,
                time: newTime,
                emphasized: true,
                accentColor:
                actionColor,
              ),

              const SizedBox(height: 16),

              _NotesReviewCard(
                notes:
                normalizedNotes,
              ),

              const SizedBox(height: 16),

              _PendingNoticeCard(
                accentColor:
                actionColor,
              ),

              const SizedBox(height: 22),

              SizedBox(
                width:
                double.infinity,
                child:
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pop();

                    onConfirm();
                  },
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    actionColor,
                    foregroundColor:
                    Colors.white,
                    elevation: 0,
                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                    ),
                  ),
                  child: Text(
                    context
                        .l10n
                        .sendAppointmentEditRequest,
                    style: theme
                        .textTheme
                        .titleSmall
                        ?.copyWith(
                      color:
                      Colors.white,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width:
                double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pop();
                  },
                  style:
                  TextButton.styleFrom(
                    foregroundColor:
                    actionColor,
                  ),
                  child: Text(
                    context
                        .l10n
                        .editButton,
                    style: theme
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                      color:
                      actionColor,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateComparisonCard
    extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final bool emphasized;
  final Color accentColor;

  const _DateComparisonCard({
    required this.title,
    required this.date,
    required this.time,
    required this.emphasized,
    required this.accentColor,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colors =
        context.colors;

    final backgroundColor =
    emphasized
        ? accentColor.withValues(
      alpha: 0.08,
    )
        : colors.surfacePrimary;

    final borderColor =
    emphasized
        ? accentColor.withValues(
      alpha: 0.32,
    )
        : colors.borderSoft;

    final iconBackground =
    emphasized
        ? accentColor.withValues(
      alpha: 0.12,
    )
        : colors.surfaceMuted;

    final iconColor =
    emphasized
        ? accentColor
        : colors.textSecondary;

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
        backgroundColor,
        borderRadius:
        BorderRadius.circular(
          18,
        ),
        border:
        Border.all(
          color:
          borderColor,
          width:
          emphasized
              ? 1.4
              : 1,
        ),
        boxShadow:
        emphasized
            ? [
          BoxShadow(
            color:
            accentColor.withValues(
              alpha: 0.10,
            ),
            blurRadius:
            12,
            offset:
            const Offset(
              0,
              5,
            ),
          ),
        ]
            : null,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration:
            BoxDecoration(
              color:
              iconBackground,
              borderRadius:
              BorderRadius.circular(
                14,
              ),
            ),
            child: Icon(
              Icons
                  .calendar_month_rounded,
              color:
              iconColor,
              size: 23,
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
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                    colors
                        .textSecondary,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  date,
                  style: theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color:
                    colors
                        .textPrimary,
                    fontWeight:
                    FontWeight.w800,
                    height: 1.4,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  time,
                  style: theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color:
                    emphasized
                        ? accentColor
                        : colors
                        .textSecondary,
                    fontWeight:
                    FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          if (emphasized) ...[
            const SizedBox(
              width: 8,
            ),
            Icon(
              Icons
                  .check_circle_rounded,
              color:
              accentColor,
              size: 22,
            ),
          ],
        ],
      ),
    );
  }
}

class _NotesReviewCard
    extends StatelessWidget {
  final String? notes;

  const _NotesReviewCard({
    required this.notes,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colors =
        context.colors;

    final hasNotes =
        notes != null &&
            notes!.isNotEmpty;

    return Container(
      width:
      double.infinity,
      padding:
      const EdgeInsets.all(
        15,
      ),
      decoration:
      BoxDecoration(
        color:
        colors.surfaceMuted,
        borderRadius:
        BorderRadius.circular(
          16,
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
            width: 38,
            height: 38,
            decoration:
            BoxDecoration(
              color:
              colors
                  .surfaceSecondary,
              borderRadius:
              BorderRadius.circular(
                12,
              ),
            ),
            child: Icon(
              Icons.notes_rounded,
              color:
              colors.textSecondary,
              size: 20,
            ),
          ),

          const SizedBox(
            width: 11,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  context
                      .l10n
                      .notesReviewLabel,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                    colors
                        .textSecondary,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  hasNotes
                      ? notes!
                      : context
                      .l10n
                      .noAppointmentNotes,
                  style: theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color:
                    hasNotes
                        ? colors
                        .textPrimary
                        : colors
                        .textSecondary,
                    fontWeight:
                    hasNotes
                        ? FontWeight
                        .w700
                        : FontWeight
                        .w600,
                    height: 1.45,
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

class _PendingNoticeCard
    extends StatelessWidget {
  final Color accentColor;

  const _PendingNoticeCard({
    required this.accentColor,
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
      const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 14,
      ),
      decoration:
      BoxDecoration(
        color:
        accentColor.withValues(
          alpha: 0.07,
        ),
        borderRadius:
        BorderRadius.circular(
          16,
        ),
        border:
        Border.all(
          color:
          accentColor.withValues(
            alpha: 0.20,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration:
            BoxDecoration(
              color:
              accentColor.withValues(
                alpha: 0.10,
              ),
              borderRadius:
              BorderRadius.circular(
                11,
              ),
            ),
            child: Icon(
              Icons
                  .info_outline_rounded,
              color:
              accentColor,
              size: 20,
            ),
          ),

          const SizedBox(
            width: 11,
          ),

          Expanded(
            child: Text(
              context
                  .l10n
                  .appointmentEditPendingNotice,
              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color:
                colors
                    .textSecondary,
                height: 1.5,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}