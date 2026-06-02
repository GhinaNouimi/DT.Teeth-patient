import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../models/appointment_ui_model.dart';
import '../models/appointments_store.dart';
import '../widgets/appointment/appointment_time_chip.dart';

class RescheduleAppointmentScreen extends StatefulWidget {
  final AppointmentUiModel appointment;

  const RescheduleAppointmentScreen({super.key, required this.appointment});

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
        '09:00 صباحًا',
        '10:30 صباحًا',
        '01:00 ظهرًا',
        '04:30 مساءً',
        '06:00 مساءً',
      ];
    });
  }

  bool _isDateAvailable(DateTime date) {
    final now = DateTime.now();
    return date.isAfter(now.subtract(const Duration(days: 1))) &&
        date.isBefore(now.add(const Duration(days: 30)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final currentDate = DateFormat(
      'EEEE d MMMM y',
      'ar_SA',
    ).format(widget.appointment.appointmentDate);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AppTopBar(
                title: 'تعديل الموعد',
                onBackTap: () => context.pop(),
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                children: [
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
                          '$currentDate - ${widget.appointment.appointmentTime}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'اختر تاريخًا جديدًا',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w800,
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
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDate, day),
                      enabledDayPredicate: _isDateAvailable,
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!_isDateAvailable(selectedDay)) return;
                        setState(() {
                          _selectedDate = selectedDay;
                          _focusedDay = focusedDay;
                          _selectedTime = null;
                        });
                        _loadAvailableTimes(selectedDay);
                      },
                      onPageChanged: (focusedDay) {
                        setState(() {
                          _focusedDay = focusedDay;
                        });
                      },
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
                          color: colors.buttonPrimary.withValues(alpha: 0.45),
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
                        leftChevronIcon: Icon(
                          Icons.chevron_left_rounded,
                          color: colors.buttonPrimary,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right_rounded,
                          color: colors.buttonPrimary,
                        ),
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
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _availableTimes.map((time) {
                        return AppointmentTimeChip(
                          label: time,
                          selected: _selectedTime == time,
                          available: true,
                          onTap: () {
                            setState(() {
                              _selectedTime = time;
                            });
                          },
                        );
                      }).toList(),
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
                      onPressed:
                          (_selectedDate != null && _selectedTime != null)
                          ? () async {
                              await showSuccessBottomSheet(
                                context,
                                title: 'تم إرسال طلب التعديل',
                                message:
                                    'سيتم إشعارك بعد مراجعة الموعد الجديد وتأكيده من قبل العيادة.',
                                buttonText: 'العودة',
                                onPressed: () {
                                  final updatedAppointment = widget.appointment
                                      .copyWith(
                                        appointmentDate: _selectedDate!,
                                        appointmentTime: _selectedTime!,
                                      );

                                  AppointmentsStore.instance.updateAppointment(
                                    updatedAppointment,
                                  );
                                  context.go('${AppRoutes.home}?tab=2');
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
          ],
        ),
      ),
    );
  }
}
