import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../models/appointment_ui_model.dart';

class NextAppointmentSection extends StatelessWidget {
  final AppointmentUiModel appointment;

  const NextAppointmentSection({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    final formattedDate = DateFormat(
      'EEEE d MMMM',
      'ar_SA',
    ).format(appointment.appointmentDate);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'موعدك القادم',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colors.surfaceSecondary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: colors.navBarItem,
                  size: 18,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    '$formattedDate - ${appointment.appointmentTime}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Text(
            '${appointment.service.displayName} مع ${appointment.doctor.name}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Icon(
                Icons.access_time_filled_rounded,
                size: 18,
                color: colors.buttonPrimary,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  'يرجى الوصول إلى العيادة قبل الموعد بـ 10 دقائق.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.push(AppRoutes.appointmentDetails, extra: appointment);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.buttonSecondary,
                foregroundColor: colors.textPrimary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text('عرض التفاصيل'),
            ),
          ),
        ],
      ),
    );
  }
}
