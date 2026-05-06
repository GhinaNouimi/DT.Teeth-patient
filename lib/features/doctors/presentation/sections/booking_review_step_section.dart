import 'package:flutter/material.dart';

import '../../../../core/theme/app_color_tokens.dart';
import '../models/doctor_ui_model.dart';
import '../widgets/booking_doctor_summary_card.dart';
import '../widgets/booking_review_row.dart';

class BookingReviewStepSection extends StatelessWidget {
  final DoctorUiModel doctor;
  final AppColorTokens colors;
  final ThemeData theme;
  final DateTime selectedDate;
  final String selectedTime;
  final TextEditingController notesController;
  final String formattedDate;
  final VoidCallback onBack;
  final VoidCallback onConfirm;

  const BookingReviewStepSection({
    super.key,
    required this.doctor,
    required this.colors,
    required this.theme,
    required this.selectedDate,
    required this.selectedTime,
    required this.notesController,
    required this.formattedDate,
    required this.onBack,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      children: [
        BookingDoctorSummaryCard(
          doctor: doctor,
          colors: colors,
          theme: theme,
          highlighted: true,
        ),
        const SizedBox(height: 24),
        Text(
          'تفاصيل الموعد',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        BookingReviewRow(
          icon: Icons.calendar_today_rounded,
          label: 'التاريخ',
          value: formattedDate,
          colors: colors,
          theme: theme,
        ),
        const SizedBox(height: 12),
        BookingReviewRow(
          icon: Icons.schedule_rounded,
          label: 'الوقت',
          value: selectedTime,
          colors: colors,
          theme: theme,
        ),
        const SizedBox(height: 24),
        Text(
          'ملاحظات إضافية (اختياري)',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: notesController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'أخبر الطبيب عن حالتك أو أي معلومات مهمة',
            hintStyle: TextStyle(color: colors.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colors.borderSoft),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('الرجوع'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onConfirm,
                icon: const Icon(Icons.check_rounded),
                label: const Text('تأكيد الحجز'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
