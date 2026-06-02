// lib/features/appointments/presentation/widgets/appointment_card_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme_extensions.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surfacePrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.borderSoft),
          boxShadow: [
            BoxShadow(
              color: colors.buttonPrimary.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // صورة الطبيب
            CircleAvatar(
              radius: 28,
              backgroundColor: colors.surfaceMuted,
              child: Text(
                appointment.doctor.imageUrl,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(width: 12),
            // معلومات الموعد
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // حالة الموعد
                  _StatusBadge(
                    status: appointment.status,
                    colors: colors,
                    theme: theme,
                  ),
                  const SizedBox(height: 6),
                  // اسم الطبيب
                  Text(
                    appointment.doctor.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // التخصص والخدمة
                  Text(
                    appointment.service.displayName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // التاريخ والوقت
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: colors.buttonPrimary,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat(
                          'd MMM',
                          'ar_SA',
                        ).format(appointment.appointmentDate),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.schedule_rounded,
                        color: colors.buttonPrimary,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        appointment.appointmentTime,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // نوع الموعد
            if (appointment.type == AppointmentType.emergency)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE74C3C).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '️ طارئ',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFFE74C3C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            else
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: colors.buttonPrimary,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final AppointmentStatus status;
  final dynamic colors;
  final ThemeData theme;

  const _StatusBadge({
    required this.status,
    required this.colors,
    required this.theme,
  });

  Color _getStatusColor() {
    switch (status) {
      case AppointmentStatus.confirmed:
        return const Color(0xFF2E9D57);
      case AppointmentStatus.pending:
        return const Color(0xFFF39C12);
      case AppointmentStatus.cancelled:
        return const Color(0xFFE74C3C);
      case AppointmentStatus.completed:
        return const Color(0xFF27AE60);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.displayName,
        style: theme.textTheme.labelSmall?.copyWith(
          color: _getStatusColor(),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
