import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../dialogs/cancel_appointment_dialog.dart';
import '../models/appointment_ui_model.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final AppointmentUiModel appointment;

  const AppointmentDetailsScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final formattedDate = DateFormat(
      'EEEE d MMMM y',
      'ar_SA',
    ).format(appointment.appointmentDate);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AppTopBar(
                title: 'تفاصيل الموعد',
                onBackTap: () => context.pop(),
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                children: [
                  // حالة الموعد
                  _SectionTitle(title: 'حالة الموعد'),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surfaceMuted,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      appointment.status.displayName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Divider(color: colors.borderSoft),

                  const SizedBox(height: 22),

                  // التفاصيل
                  _SectionTitle(title: 'التفاصيل'),

                  const SizedBox(height: 16),

                  _InfoRow(
                    icon: Icons.calendar_today_rounded,
                    title: 'التاريخ',
                    value: formattedDate,
                  ),

                  const SizedBox(height: 16),

                  _InfoRow(
                    icon: Icons.access_time_rounded,
                    title: 'الوقت',
                    value: appointment.appointmentTime,
                  ),

                  const SizedBox(height: 16),

                  _InfoRow(
                    icon: Icons.medical_services_outlined,
                    title: 'الخدمة',
                    value: appointment.service.displayName,
                  ),

                  const SizedBox(height: 22),

                  Divider(color: colors.borderSoft),

                  const SizedBox(height: 22),

                  // الطبيب
                  _SectionTitle(title: 'الطبيب'),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: colors.surfaceMuted,
                        // child: Text(
                        //   appointment.doctor.imageUrl,
                        //   style: const TextStyle(fontSize: 28),
                        // ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   appointment.doctor.name,
                            //   style: theme.textTheme.bodyLarge?.copyWith(
                            //     color: colors.textPrimary,
                            //     fontWeight: FontWeight.w800,
                            //   ),
                            // ),

                            const SizedBox(height: 4),

                            // Text(
                            //   appointment.doctor.specialty,
                            //   style: theme.textTheme.bodyMedium?.copyWith(
                            //     color: colors.textSecondary,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  Divider(color: colors.borderSoft),

                  const SizedBox(height: 22),

                  // المدة التقريبية
                  _SectionTitle(title: 'المدة التقريبية للموعد'),

                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surfaceMuted,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer_outlined, color: colors.buttonPrimary),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            '${appointment.durationMinutes} دقيقة تقريبًا',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  Divider(color: colors.borderSoft),

                  const SizedBox(height: 22),

                  // تعليمات الطبيب
                  _SectionTitle(title: 'تعليمات الطبيب'),

                  const SizedBox(height: 14),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: colors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      appointment.doctorNotes ?? 'لا توجد تعليمات حالياً.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.textPrimary,
                        height: 1.7,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // ملاحظات المريض
                  if (appointment.patientNotes != null &&
                      appointment.patientNotes!.trim().isNotEmpty) ...[
                    const SizedBox(height: 22),

                    Divider(color: colors.borderSoft),

                    const SizedBox(height: 22),

                    _SectionTitle(title: 'ملاحظتك'),

                    const SizedBox(height: 14),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colors.surfaceMuted,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        appointment.patientNotes!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                          height: 1.7,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  if (appointment.canReschedule || appointment.canCancel)
                    Row(
                      children: [
                        if (appointment.canReschedule)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.push(
                                  AppRoutes.rescheduleAppointment,
                                  extra: appointment,
                                );
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.buttonPrimary,

                                foregroundColor: colors.textPrimary,

                                elevation: 0,

                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),

                              icon: const Icon(
                                Icons.edit_calendar_rounded,
                                size: 18,
                              ),

                              label: const Text('تعديل الموعد'),
                            ),
                          ),

                        if (appointment.canReschedule && appointment.canCancel)
                          const SizedBox(width: 12),

                        if (appointment.canCancel)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await showDialog<void>(
                                  context: context,
                                  builder: (_) => CancelAppointmentDialog(
                                    appointmentId: appointment.id,
                                  ),
                                );
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.danger,

                                foregroundColor: colors.textInverse,

                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),

                              icon: const Icon(Icons.close_rounded, size: 18),

                              label: const Text('إلغاء الموعد'),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        color: colors.textPrimary,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
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
    final theme = Theme.of(context);
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colors.surfaceMuted,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, size: 20, color: colors.buttonPrimary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
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
