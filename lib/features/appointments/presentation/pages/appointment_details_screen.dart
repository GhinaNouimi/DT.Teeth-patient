import 'package:dt_teeth/features/appointments/presentation/widgets/AppointmentDoctorCard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../dialogs/cancel_appointment_dialog.dart';
import '../widgets/AppointmentDetailRow.dart';

import '../widgets/appointment_section_block.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const AppTopBar(title: 'تفاصيل الموعد'),
            const SizedBox(height: 18),

            Center(
              child: Text(
                'موعدك',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '24 أكتوبر',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                'الخميس - 10:30 صباحًا',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 22),
            const AppointmentDoctorCard(),
            const SizedBox(height: 18),
            AppointmentSectionBlock(
              title: 'معلومات الموعد',
              child: const Column(
                children: [
                  AppointmentDetailRow(
                    label: 'الخدمة',
                    value: 'تنظيف روتيني',
                  ),
                  SizedBox(height: 14),
                  AppointmentDetailRow(
                    label: 'المدة',
                    value: '45 دقيقة',
                  ),
                  SizedBox(height: 14),
                  AppointmentDetailRow(
                    label: 'الحالة',
                    value: 'مؤكد',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppointmentSectionBlock(
              title: 'موقع العيادة',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DT.Teeth  Center',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'دمشق - جرمانا - بناء المركز الطبي - الطابق الثاني',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppointmentSectionBlock(
              title: 'تعليمات',
              child: Column(
                children: const [
                  _InstructionRow(
                    text: 'يرجى الحضور قبل الموعد بـ 15 دقيقة.',
                  ),
                  SizedBox(height: 12),
                  _InstructionRow(
                    text: 'تجنب القهوة أو المشروبات الداكنة قبل التنظيف بساعتين.',
                  ),
                  SizedBox(height: 12),
                  _InstructionRow(
                    text: 'أحضر أي صور أو تقارير سابقة إن وجدت.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.push(AppRoutes.rescheduleAppointment),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.surfaceMuted,
                      foregroundColor: colors.navBarItem,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.edit_calendar_rounded, size: 18),
                    label: const Text('تعديل الموعد'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await showDialog<void>(
                        context: context,
                        builder: (_) => const CancelAppointmentDialog(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.danger,
                      foregroundColor: colors.textInverse,
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
    );
  }
}

class _InstructionRow extends StatelessWidget {
  final String text;

  const _InstructionRow({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 18,
          color: colors.buttonPrimary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
