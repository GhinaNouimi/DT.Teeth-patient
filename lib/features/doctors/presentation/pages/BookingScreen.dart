import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_color_tokens.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/booking_bottom_sheet.dart';
import '../models/doctor_ui_model.dart';

class BookingScreen extends StatefulWidget {
  final DoctorUiModel doctor;

  const BookingScreen({super.key, required this.doctor});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int? selectedDateIndex;
  int? selectedTimeIndex;
  int currentStep = 0; // 0: التاريخ والوقت، 1: المراجعة

  late List<DateTime> dates;

  final List<String> times = [
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '13:00',
    '13:30',
  ];

  @override
  void initState() {
    super.initState();
    dates = List.generate(
      14,
          (index) => DateTime.now().add(Duration(days: index)),
    );
  }

  String _getArabicDayName(int weekday) {
    const days = [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد'
    ];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final doctor = widget.doctor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('حجز موعد'),
        centerTitle: true,
        elevation: 0,
      ),
      body: currentStep == 0
          ? _buildSelectDateTimeStep(colors, theme, doctor)
          : _buildReviewStep(colors, theme, doctor),
    );
  }

  /// الخطوة 1: اختيار التاريخ والوقت
  Widget _buildSelectDateTimeStep(
      AppColorTokens colors,
      ThemeData theme,
      DoctorUiModel doctor,
      ) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        /// معلومات الطبيب
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surfacePrimary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.borderSoft),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: colors.surfaceMuted,
                child: Text(
                  doctor.imageUrl,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    doctor.specialty,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 24),

        /// اختيار التاريخ
        Text(
          'الخطوة 1: اختر التاريخ',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected = selectedDateIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDateIndex = index;
                    selectedTimeIndex = null;
                  });
                },
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.buttonPrimary : colors.surfaceMuted,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getArabicDayName(date.weekday),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${date.month}/${date.year}',
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? Colors.white70 : colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),

        /// اختيار الوقت
        Text(
          'الخطوة 2: اختر الوقت',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          itemCount: times.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.5,
          ),
          itemBuilder: (context, index) {
            final isSelected = selectedTimeIndex == index;

            return GestureDetector(
              onTap: selectedDateIndex == null
                  ? null
                  : () {
                setState(() {
                  selectedTimeIndex = index;
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedDateIndex == null
                      ? colors.backgroundSecondary
                      : isSelected
                      ? colors.buttonPrimary
                      : colors.surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  times[index],
                  style: TextStyle(
                    color: selectedDateIndex == null
                        ? colors.textSecondary
                        : isSelected
                        ? Colors.white
                        : colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 30),

        /// زر المتابعة
        ElevatedButton(
          onPressed: (selectedDateIndex != null && selectedTimeIndex != null)
              ? () {
            setState(() {
              currentStep = 1;
            });
          }
              : null,
          child: const Text('المتابعة للمراجعة'),
        ),
      ],
    );
  }

  /// الخطوة 2: مراجعة الحجز
  Widget _buildReviewStep(
      AppColorTokens colors,
      ThemeData theme,
      DoctorUiModel doctor,
      ) {
    final selectedDate = dates[selectedDateIndex!];
    final selectedTime = times[selectedTimeIndex!];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'الخطوة 3: راجع حجزك',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        /// ملخص الطبيب
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surfaceSecondary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.borderSoft),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colors.surfaceMuted,
                    child: Text(
                      doctor.imageUrl,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        doctor.specialty,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        /// تفاصيل الموعد
        Text(
          'تفاصيل الموعد',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _ReviewRow(
          icon: Icons.calendar_today_rounded,
          label: 'التاريخ',
          value: '${_getArabicDayName(selectedDate.weekday)} ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
          colors: colors,
          theme: theme,
        ),
        const SizedBox(height: 12),
        _ReviewRow(
          icon: Icons.schedule_rounded,
          label: 'الوقت',
          value: selectedTime,
          colors: colors,
          theme: theme,
        ),
        const SizedBox(height: 24),

        /// ملاحظة
        Text(
          'ملاحظة',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'هل لديك ملاحظات أو أسئلة؟',
            hintStyle: TextStyle(color: colors.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colors.borderSoft),
            ),
          ),
        ),
        const SizedBox(height: 30),

        /// أزرار الإجراءات
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    currentStep = 0;
                  });
                },
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('الرجوع'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showConfirmation(context);
                },
                icon: const Icon(Icons.check_rounded),
                label: const Text('تأكيد الحجز'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// عرض تأكيد الحجز
  void _showConfirmation(BuildContext context) {
    final selectedDate = dates[selectedDateIndex!];
    final selectedTime = times[selectedTimeIndex!];
    final dateFormatted =
        '${_getArabicDayName(selectedDate.weekday)} ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';

    // استدعاء ال bottom sheet الحجز
    showBookingBottomSheet(
      context,
      doctorName: widget.doctor.name,
      date: dateFormatted,
      time: selectedTime,
      buttonText: 'العودة ',
      onPressed: () {
        // العودة لصفحة الأطباء
        context.go('/doctors');
      },
    );
  }
  /// رسالة النجاح
  // void _showSuccessMessage(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           const SizedBox(height: 20),
  //           Container(
  //             width: 80,
  //             height: 80,
  //             decoration: BoxDecoration(
  //               color: const Color(0xFFE8F5E9),
  //               borderRadius: BorderRadius.circular(40),
  //             ),
  //             child: const Center(
  //               child: Icon(
  //                 Icons.check_circle,
  //                 color: Color(0xFF2E9D57),
  //                 size: 60,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 20),
  //           const Text(
  //             'تم حجز الموعد بنجاح! ✅',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             textAlign: TextAlign.center,
  //           ),
  //           const SizedBox(height: 10),
  //           const Text(
  //             'سيتم إرسال تفاصيل الموعد إلى بريدك الإلكتروني',
  //             style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
  //             textAlign: TextAlign.center,
  //           ),
  //           const SizedBox(height: 24),
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //               context.go('/doctors');
  //             },
  //             style: ElevatedButton.styleFrom(
  //               minimumSize: const Size(double.infinity, 48),
  //             ),
  //             child: const Text('العودة للأطباء'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class _ReviewRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final AppColorTokens colors;
  final ThemeData theme;

  const _ReviewRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: colors.buttonPrimary, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String label;
  final String value;

  const _ConfirmRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}