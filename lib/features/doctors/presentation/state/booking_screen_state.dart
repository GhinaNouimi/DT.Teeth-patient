import 'package:flutter/material.dart';

class BookingScreenState {
  final DateTime? selectedDate;
  final String? selectedTime;
  final int currentStep;
  final DateTime focusedDay;
  final TextEditingController notesController;

  const BookingScreenState({
    required this.selectedDate,
    required this.selectedTime,
    required this.currentStep,
    required this.focusedDay,
    required this.notesController,
  });

  bool get canContinue => selectedDate != null && selectedTime != null;

  BookingScreenState copyWith({
    DateTime? selectedDate,
    String? selectedTime,
    int? currentStep,
    DateTime? focusedDay,
    TextEditingController? notesController,
    bool clearSelectedTime = false,
  }) {
    return BookingScreenState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: clearSelectedTime
          ? null
          : (selectedTime ?? this.selectedTime),
      currentStep: currentStep ?? this.currentStep,
      focusedDay: focusedDay ?? this.focusedDay,
      notesController: notesController ?? this.notesController,
    );
  }
}
