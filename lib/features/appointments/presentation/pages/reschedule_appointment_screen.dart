import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';

class RescheduleAppointmentScreen extends StatefulWidget {
  const RescheduleAppointmentScreen({super.key});

  @override
  State<RescheduleAppointmentScreen> createState() =>
      _RescheduleAppointmentScreenState();
}

class _RescheduleAppointmentScreenState
    extends State<RescheduleAppointmentScreen> {
  int? _selectedDateIndex;
  int? _selectedTimeIndex;

  final List<String> _availableDates = const [
    'الأحد 4 مايو',
    'الاثنين 5 مايو',
    'الثلاثاء 6 مايو',
    'الأربعاء 7 مايو',
  ];

  final List<String> _availableTimes = const [
    '09:00 صباحًا',
    '10:30 صباحًا',
    '01:00 ظهرًا',
    '04:30 مساءً',
    '06:00 مساءً',
  ];

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
            const AppTopBar(title: 'تعديل الموعد'),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.surfacePrimary,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: colors.borderSoft),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الموعد الحالي',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'الاثنين 29 أبريل 2026 - 05:30 مساءً',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'اختر تاريخًا جديدًا',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                _availableDates.length,
                    (index) => ChoiceChip(
                  label: Text(_availableDates[index]),
                  selected: _selectedDateIndex == index,
                  onSelected: (_) {
                    setState(() => _selectedDateIndex = index);
                  },
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'اختر وقتًا متاحًا',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                _availableTimes.length,
                    (index) => ChoiceChip(
                  label: Text(_availableTimes[index]),
                  selected: _selectedTimeIndex == index,
                  onSelected: (_) {
                    setState(() => _selectedTimeIndex = index);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surfaceSecondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'سيتم إرسال طلب تعديل الموعد إلى العيادة، وستتلقى إشعارًا عند تأكيد الموعد الجديد.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_selectedDateIndex != null && _selectedTimeIndex != null)
                    ? () async {
                  await showSuccessBottomSheet(
                    context,
                    title: 'تم إرسال طلب التعديل',
                    message: 'سيتم إشعارك بعد مراجعة الموعد الجديد وتأكيده من قبل العيادة.',
                    buttonText: 'العودة للرئيسية',
                    onPressed: () {
                      context.go(AppRoutes.home);
                    },
                  );
                }
                    : null,

                child: const Text('إرسال طلب التعديل'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
