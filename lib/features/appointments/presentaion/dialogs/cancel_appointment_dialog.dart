import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../models/appointments_store.dart';

class CancelAppointmentDialog extends StatelessWidget {
  final String appointmentId;

  const CancelAppointmentDialog({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return AlertDialog(
      backgroundColor: colors.surfacePrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        'إلغاء الموعد',
        style: theme.textTheme.titleLarge?.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Text(
        'هل تريد إلغاء هذا الموعد؟ سيتم تحديث حالة الموعد مباشرة.',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colors.textSecondary,
          height: 1.6,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              AppointmentsStore.instance.cancelAppointment(appointmentId);

              await showSuccessBottomSheet(
                context,
                title: 'تم إلغاء الموعد',
                message: 'تم تحديث حالة الموعد بنجاح.',
                buttonText: 'العودة للمواعيد',
                onPressed: () {
                  context.go('${AppRoutes.home}?tab=2');
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.danger,
              foregroundColor: colors.textInverse,
            ),
            child: const Text('تأكيد الإلغاء'),
          ),
        ),
      ],
    );
  }
}
