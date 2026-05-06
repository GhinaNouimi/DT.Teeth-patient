import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/booking_bottom_sheet.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../data/booking_slots_data.dart';
import '../models/doctor_ui_model.dart';
import '../sections/booking_date_step_section.dart';
import '../sections/booking_review_step_section.dart';
import '../state/booking_screen_state.dart';
import '../utils/booking_date_utils.dart';

class BookingScreen extends StatefulWidget {
  final DoctorUiModel doctor;

  const BookingScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late BookingScreenState _state;

  @override
  void initState() {
    super.initState();
    _state = BookingScreenState(
      selectedDate: null,
      selectedTime: null,
      currentStep: 0,
      focusedDay: DateTime.now(),
      notesController: TextEditingController(),
    );
  }

  @override
  void dispose() {
    _state.notesController.dispose();
    super.dispose();
  }

  bool _isDateAvailable(DateTime date) {
    return BookingDateUtils.isDateAvailable(
      date,
      BookingSlotsData.availableDays,
    );
  }

  void _selectDate(DateTime date) {
    setState(() {
      _state = _state.copyWith(
        selectedDate: date,
        clearSelectedTime: true,
      );
    });
  }

  void _changeFocusedDay(DateTime day) {
    setState(() {
      _state = _state.copyWith(focusedDay: day);
    });
  }

  void _selectTime(String time) {
    setState(() {
      _state = _state.copyWith(selectedTime: time);
    });
  }

  void _goToReviewStep() {
    setState(() {
      _state = _state.copyWith(currentStep: 1);
    });
  }

  void _goBackToSelection() {
    setState(() {
      _state = _state.copyWith(currentStep: 0);
    });
  }

  void _showConfirmation() {
    final formattedDate = BookingDateUtils.formatReviewDate(_state.selectedDate!);

    showBookingBottomSheet(
      context,
      doctorName: widget.doctor.name,
      date: formattedDate,
      time: _state.selectedTime!,
      buttonText: 'العودة للأطباء',
      onPressed: () {
        context.go(AppRoutes.doctors);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: AppTopBar(
                title: _state.currentStep == 0 ? 'حجز موعد' : 'مراجعة الحجز',
                onBackTap: _state.currentStep == 0 ? () => context.pop() : _goBackToSelection,
              ),
            ),
            Expanded(
              child: _state.currentStep == 0
                  ? BookingDateStepSection(
                doctor: widget.doctor,
                colors: colors,
                theme: theme,
                focusedDay: _state.focusedDay,
                selectedDate: _state.selectedDate,
                selectedTime: _state.selectedTime,
                times: BookingSlotsData.times,
                isDateAvailable: _isDateAvailable,
                onDaySelected: _selectDate,
                onPageChanged: _changeFocusedDay,
                onTimeSelected: _selectTime,
                onContinue: _goToReviewStep,
              )
                  : BookingReviewStepSection(
                doctor: widget.doctor,
                colors: colors,
                theme: theme,
                selectedDate: _state.selectedDate!,
                selectedTime: _state.selectedTime!,
                notesController: _state.notesController,
                formattedDate: BookingDateUtils.formatReviewDate(_state.selectedDate!),
                onBack: _goBackToSelection,
                onConfirm: _showConfirmation,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
