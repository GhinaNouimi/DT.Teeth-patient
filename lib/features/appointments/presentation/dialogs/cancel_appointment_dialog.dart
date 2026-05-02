import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/success_bottom_sheet.dart';

class CancelAppointmentDialog extends StatelessWidget {
  const CancelAppointmentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return AlertDialog(
      backgroundColor: colors.surfacePrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      title: Text(
        'إلغاء الموعد',
        style: theme.textTheme.titleLarge?.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Text(
        'هل تريد إرسال طلب إلغاء هذا الموعد؟\nسيصلك إشعار عند تأكيد الإلغاء من قبل العيادة.',
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

              await showSuccessBottomSheet(
                context,
                title: 'تم إرسال طلب الإلغاء',
                message: 'سيتم إشعارك فور تأكيد إلغاء الموعد من قبل العيادة.',
                buttonText: 'العودة',
                onPressed: () {
                  context.go(AppRoutes.home);
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
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.navBarItem,
              side: BorderSide(color: colors.borderSoft),
            ),
            child: const Text('رجوع'),
          ),
        ),
      ],
    );
  }
}
