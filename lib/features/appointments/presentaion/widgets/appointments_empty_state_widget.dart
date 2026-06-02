import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class AppointmentsEmptyStateWidget extends StatelessWidget {
  final bool isUpcoming;

  const AppointmentsEmptyStateWidget({super.key, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),

          Icon(
            isUpcoming ? Icons.calendar_today_rounded : Icons.history_rounded,
            size: 64,
            color: colors.buttonPrimary.withValues(alpha: 0.2),
          ),

          const SizedBox(height: 16),

          Text(
            isUpcoming ? 'لا توجد مواعيد قادمة' : 'لا توجد مواعيد سابقة',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            isUpcoming
                ? 'ابدأ بحجز موعدك الأول الآن'
                : 'لم تسجل مواعيد سابقة بعد',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
