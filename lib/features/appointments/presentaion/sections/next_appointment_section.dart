import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../generated/assets.dart';
import '../../domain/entities/appointment_entity.dart';

class NextAppointmentSection extends StatelessWidget {
  final AppointmentEntity appointment;

  const NextAppointmentSection({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final languageCode =
        Localizations.localeOf(context).languageCode;

    final dateLocale =
    languageCode == 'ar' ? 'ar_SA' : 'en_US';

    final dayName = DateFormat(
      languageCode == 'ar' ? 'EEEE' : 'EEE',
      dateLocale,
    ).format(appointment.appointmentTime);

    final dayNumber = DateFormat(
      'd',
      dateLocale,
    ).format(appointment.appointmentTime);

    final monthName = DateFormat(
      'MMMM',
      dateLocale,
    ).format(appointment.appointmentTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: l10n.nextAppointment,
        ),
        const SizedBox(height: 14),
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(26),
          child: InkWell(
            borderRadius: BorderRadius.circular(26),
            onTap: () {
              context.push(
                AppRoutes.appointmentDetails,
                extra: appointment.id,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: colors.surfacePrimary,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: colors.borderSoft,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _DateBlock(
                    dayName: dayName,
                    dayNumber: dayNumber,
                    monthName: monthName,
                  ),
                  Container(
                    width: 1,
                    height: 76,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    color: colors.borderSoft,
                  ),
                  Expanded(
                    child: _AppointmentInfo(
                      appointment: appointment,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 76,
                    height: 76,
                    child: Image.asset(
                      Assets.dentalChair,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: colors.surfaceMuted,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.calendar_month_rounded,
            color: colors.navBarItem,
            size: 21,
          ),
        ),
      ],
    );
  }
}

class _DateBlock extends StatelessWidget {
  final String dayName;
  final String dayNumber;
  final String monthName;

  const _DateBlock({
    required this.dayName,
    required this.dayNumber,
    required this.monthName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return SizedBox(
      width: 62,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            dayName,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            dayNumber,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            monthName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentInfo extends StatelessWidget {
  final AppointmentEntity appointment;

  const _AppointmentInfo({
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    final languageCode =
        Localizations.localeOf(context).languageCode;

    final dateLocale =
    languageCode == 'ar' ? 'ar_SA' : 'en_US';

    final formattedTime = DateFormat(
      'hh:mm a',
      dateLocale,
    ).format(appointment.appointmentTime);

    final appointmentType =
    appointment.localizedAppointmentType(
      languageCode,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appointmentType,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          appointment.dentistName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: colors.textSecondary,
                  size: 15,
                ),
                const SizedBox(width: 4),
                Text(
                  formattedTime,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: colors.surfaceMuted,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: colors.borderSoft,
                ),
              ),
              child: Text(
                l10n.viewDetails,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}