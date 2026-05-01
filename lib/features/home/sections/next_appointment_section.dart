import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../core/routing/app_routes.dart';

class NextAppointmentSection extends StatelessWidget {
  const NextAppointmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

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
                Icon(Icons.calendar_today_rounded, color: colors.navBarItem, size: 18),
                const SizedBox(width: 8),
                Text(
                  'الاثنين 29 أبريل - 05:30 مساءً',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'تنظيف وتقييم عام مع د. محمد',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.access_time_filled_rounded, size: 18, color: colors.buttonPrimary),
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
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(

              onPressed: () => context.push(AppRoutes.appointmentDetails),
              child: const Text('عرض التفاصيل'),
            ),
          ),

        ],
      ),
    );
  }
}
