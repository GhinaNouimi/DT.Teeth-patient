import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

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
  DateTime? _selectedDate;
  String? _selectedTime;
  DateTime _focusedDay = DateTime.now();
  List<String> _availableTimes = [];

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
  }

  void _loadAvailableTimes(DateTime date) {
    setState(() {
      _availableTimes = [
        '09:00 ',
        '10:30 ',
        '01:00 ',
        '04:30 ',
        '06:00 ',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const AppTopBar(title: 'تعديل الموعد'),
            const SizedBox(height: 18),

            /// 🔴 الموعد الحالي
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

            const SizedBox(height: 22),

            /// 🔴 اختيار التاريخ
            Text(
              'اختر تاريخًا جديدًا',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: colors.surfacePrimary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colors.borderSoft),
              ),
              padding: const EdgeInsets.all(16),
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 30)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) =>
                    isSameDay(_selectedDate, day),

                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                    _focusedDay = focusedDay;

                    /// reset الوقت
                    _selectedTime = null;

                    _loadAvailableTimes(selectedDay);
                  });
                },

                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
            ),

            const SizedBox(height: 22),

            /// 🔴 اختيار الوقت
            Text(
              'اختر وقتًا متاحًا',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),

            if (_selectedDate == null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'اختر التاريخ أولاً لعرض الأوقات المتاحة',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              )
            else
              GridView.builder(
                itemCount: _availableTimes.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.3,
                ),
                itemBuilder: (context, index) {
                  final time = _availableTimes[index];
                  final isSelected = _selectedTime == time;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTime = time;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.buttonPrimary
                            : colors.surfaceMuted,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : colors.borderSoft,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          time,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : colors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 24),

            /// 🔴 ملاحظة
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

            /// 🔴 زر الإرسال
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_selectedDate != null &&
                    _selectedTime != null)
                    ? () async {
                  await showSuccessBottomSheet(
                    context,
                    title: 'تم إرسال طلب التعديل',
                    message:
                    'سيتم إشعارك بعد مراجعة الموعد الجديد وتأكيده من قبل العيادة.',
                    buttonText: 'العودة',
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