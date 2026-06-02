import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/app_color_tokens.dart';
import '../models/doctor_ui_model.dart';
import '../utils/booking_date_utils.dart';
import '../widgets/booking_doctor_summary_card.dart';
import '../widgets/booking_info_banner.dart';
import '../widgets/booking_time_tile.dart';

class BookingDateStepSection extends StatelessWidget {
  final DoctorUiModel doctor;
  final AppColorTokens colors;
  final ThemeData theme;
  final DateTime focusedDay;
  final DateTime? selectedDate;
  final String? selectedTime;
  final List<String> times;
  final bool Function(DateTime date) isDateAvailable;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onPageChanged;
  final ValueChanged<String> onTimeSelected;
  final VoidCallback onContinue;

  const BookingDateStepSection({
    super.key,
    required this.doctor,
    required this.colors,
    required this.theme,
    required this.focusedDay,
    required this.selectedDate,
    required this.selectedTime,
    required this.times,
    required this.isDateAvailable,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.onTimeSelected,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      children: [
        BookingDoctorSummaryCard(doctor: doctor, colors: colors, theme: theme),
        const SizedBox(height: 28),
        Text(
          'الخطوة 1: اختر التاريخ',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surfacePrimary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.borderSoft),
          ),
          child: TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 30)),
            focusedDay: focusedDay,
            selectedDayPredicate: (day) => isSameDay(selectedDate, day),
            onDaySelected: (day, focused) {
              if (isDateAvailable(day)) {
                onDaySelected(day);
                onPageChanged(focused);
              }
            },
            onPageChanged: onPageChanged,
            enabledDayPredicate: isDateAvailable,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              defaultDecoration: BoxDecoration(
                color: colors.surfaceMuted,
                shape: BoxShape.circle,
              ),
              weekendDecoration: BoxDecoration(
                color: colors.surfaceMuted,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: colors.buttonPrimary,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              todayDecoration: BoxDecoration(
                color: colors.buttonPrimary.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              disabledDecoration: BoxDecoration(
                color: colors.backgroundSecondary,
                shape: BoxShape.circle,
              ),
              disabledTextStyle: TextStyle(
                color: colors.textSecondary.withValues(alpha: 0.4),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle:
                  theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ) ??
                  const TextStyle(),
              leftChevronIcon: Icon(
                Icons.chevron_left_rounded,
                color: colors.buttonPrimary,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right_rounded,
                color: colors.buttonPrimary,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              weekendStyle: TextStyle(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (selectedDate != null)
          BookingInfoBanner(
            colors: colors,
            theme: theme,
            icon: Icons.check_circle_rounded,
            iconColor: colors.success,
            text:
                'التاريخ المختار: ${DateFormat('EEEE, d MMMM', 'ar_SA').format(selectedDate!)}',
          ),
        const SizedBox(height: 28),
        Text(
          'الخطوة 2: اختر الوقت',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (selectedDate == null)
          BookingInfoBanner(
            colors: colors,
            theme: theme,
            icon: Icons.info_rounded,
            text: 'اختر التاريخ أولاً لعرض الأوقات المتاحة',
          )
        else
          GridView.builder(
            itemCount: times.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemBuilder: (context, index) {
              final time = times[index];
              return GestureDetector(
                onTap: () => onTimeSelected(time),
                child: BookingTimeTile(
                  time: time,
                  isSelected: selectedTime == time,
                  colors: colors,
                ),
              );
            },
          ),
        const SizedBox(height: 36),
        ElevatedButton(
          onPressed: selectedDate != null && selectedTime != null
              ? onContinue
              : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            minimumSize: const Size(double.infinity, 0),
          ),
          child: const Text('المتابعة للمراجعة'),
        ),
      ],
    );
  }
}
