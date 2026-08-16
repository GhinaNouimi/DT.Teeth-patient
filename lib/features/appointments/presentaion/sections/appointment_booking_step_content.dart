import 'package:flutter/material.dart';

import '../../domain/entities/appointment_booking_dentist_entity.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_type_entity.dart';
import '../bloc/appointment_booking/appointment_booking_state.dart';
import '../widgets/appointment_booking_type_selector_widget.dart';
import '../widgets/appointment_notes_field.dart';
import '../widgets/appointment_type_selector_widget.dart';
import '../widgets/bookable_treatments_selector_widget.dart';
import '../widgets/doctor_selector_widget.dart';
import 'appointment_booking_review_section.dart';
import 'appointment_booking_schedule_section.dart';

class AppointmentBookingStepContent
    extends StatelessWidget {
  final AppointmentBookingLoaded state;
  final int currentStep;
  final String languageCode;
  final TextEditingController notesController;

  final ValueChanged<AppointmentBookingType>
  onBookingTypeSelected;

  final ValueChanged<int>
  onTreatmentSelected;

  final ValueChanged<AppointmentTypeEntity>
  onAppointmentTypeSelected;

  final ValueChanged<AppointmentBookingDentistEntity>
  onDentistSelected;

  final ValueChanged<DateTime>
  onSlotSelected;

  final VoidCallback onRetryDentists;
  final VoidCallback onRetrySchedule;

  final ValueChanged<int>
  onEditStep;

  const AppointmentBookingStepContent({
    super.key,
    required this.state,
    required this.currentStep,
    required this.languageCode,
    required this.notesController,
    required this.onBookingTypeSelected,
    required this.onTreatmentSelected,
    required this.onAppointmentTypeSelected,
    required this.onDentistSelected,
    required this.onSlotSelected,
    required this.onRetryDentists,
    required this.onRetrySchedule,
    required this.onEditStep,
  });

  @override
  Widget build(BuildContext context) {
    if (currentStep == 0) {
      return AppointmentBookingTypeSelectorWidget(
        selectedBookingType:
        state.selectedBookingType,
        onBookingTypeSelected:
        onBookingTypeSelected,
      );
    }

    if (state.isContinueTreatmentBooking) {
      return _buildContinueTreatmentStep();
    }

    return _buildStandardBookingStep();
  }

  Widget _buildContinueTreatmentStep() {
    switch (currentStep) {
      case 1:
        return BookableTreatmentsSelectorWidget(
          treatments:
          state.bookableTreatments,
          selectedTreatmentId:
          state.selectedTreatmentId,
          isLoading:
          state.isLoadingBookableTreatments,
          errorMessage:
          state.bookableTreatmentsErrorMessage,
          languageCode:
          languageCode,
          onTreatmentSelected:
          onTreatmentSelected,
        );

      case 2:
        return AppointmentTypeSelectorWidget(
          appointmentTypes:
          state.appointmentTypes,
          selectedType:
          state.selectedAppointmentType,
          onTypeSelected:
          onAppointmentTypeSelected,
          languageCode:
          languageCode,
        );

    // الطبيب تم تحديده تلقائيًا من العلاج.
      case 3:
        return AppointmentBookingScheduleSection(
          state:
          state,
          languageCode:
          languageCode,
          onSlotSelected:
          onSlotSelected,
          onRetrySchedule:
          onRetrySchedule,
        );

      case 4:
        return AppointmentNotesField(
          controller:
          notesController,
        );

      case 5:
        return AppointmentBookingReviewSection(
          state:
          state,
          languageCode:
          languageCode,
          notes:
          _normalizedNotes,

          onEditBookingType: () {
            onEditStep(0);
          },

          onEditTreatment: () {
            onEditStep(1);
          },

          onEditAppointmentType: () {
            onEditStep(2);
          },

          // طبيب المتابعة محسوم من العلاج.
          // سنخفي زر تعديله من Review بالخطوة التالية.
          onEditDentist: () {},

          onEditSchedule: () {
            onEditStep(3);
          },

          onEditNotes: () {
            onEditStep(4);
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStandardBookingStep() {
    switch (currentStep) {
      case 1:
        return AppointmentTypeSelectorWidget(
          appointmentTypes:
          state.appointmentTypes,
          selectedType:
          state.selectedAppointmentType,
          onTypeSelected:
          onAppointmentTypeSelected,
          languageCode:
          languageCode,
        );

      case 2:
        return DoctorSelectorWidget(
          dentists:
          state.dentists,
          selectedDentist:
          state.selectedDentist,
          onDoctorSelected:
          onDentistSelected,
          languageCode:
          languageCode,
          isLoading:
          state.isLoadingDentists,
          errorMessage:
          state.dentistsErrorMessage,
          onRetry:
          onRetryDentists,
        );

      case 3:
        return AppointmentBookingScheduleSection(
          state:
          state,
          languageCode:
          languageCode,
          onSlotSelected:
          onSlotSelected,
          onRetrySchedule:
          onRetrySchedule,
        );

      case 4:
        return AppointmentNotesField(
          controller:
          notesController,
        );

      case 5:
        return AppointmentBookingReviewSection(
          state:
          state,
          languageCode:
          languageCode,
          notes:
          _normalizedNotes,
          onEditBookingType: () {
            onEditStep(0);
          },
          onEditTreatment:
          null,
          onEditAppointmentType: () {
            onEditStep(1);
          },
          onEditDentist: () {
            onEditStep(2);
          },
          onEditSchedule: () {
            onEditStep(3);
          },
          onEditNotes: () {
            onEditStep(4);
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }

  String? get _normalizedNotes {
    final value =
    notesController.text.trim();

    if (value.isEmpty) {
      return null;
    }

    return value;
  }
}