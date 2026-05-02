import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../models/doctor_ui_model.dart';
import '../widgets/doctor_time_slot_chip.dart';

class BookDoctorAppointmentScreen extends StatefulWidget {
  final DoctorUiModel doctor;

  const BookDoctorAppointmentScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<BookDoctorAppointmentScreen> createState() =>
      _BookDoctorAppointmentScreenState();
}

class _BookDoctorAppointmentScreenState
    extends State<BookDoctorAppointmentScreen> {
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
            const AppTopBar(title: 'حجز موعد'),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.surfacePrimary,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: colors.borderSoft),
              ),
              child: Text(
                'اختر موعدًا مناسبًا مع ${widget.doctor.name}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'اختر التاريخ',
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
              'اختر الوقت',
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
                    (index) => DoctorTimeSlotChip(
                  label: _availableTimes[index],
                  selected: _selectedTimeIndex == index,
                  onTap: () {
                    setState(() => _selectedTimeIndex = index);
                  },
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
                    title: 'تم إرسال طلب الحجز',
                    message: 'سيتم إشعارك بعد تأكيد الموعد من قبل العيادة.',
                    buttonText: 'العودة',
                    onPressed: () {
                      context.go(AppRoutes.home);
                    },
                  );
                }
                    : null,
                child: const Text('إرسال طلب الحجز'),
              ),
            ),
          ],

        ),
      ),
    );
  }
}
