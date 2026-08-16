import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/show_appointment_details_use_case.dart';
import '../../../domain/usecases/show_dentist_schedule_use_case.dart';
import '../../../domain/usecases/update_appointment_use_case.dart';
import 'appointment_edit_event.dart';
import 'appointment_edit_state.dart';

class AppointmentEditBloc
    extends Bloc<
        AppointmentEditEvent,
        AppointmentEditState> {
  final ShowAppointmentDetailsUseCase
  showAppointmentDetailsUseCase;

  final ShowDentistScheduleUseCase
  showDentistScheduleUseCase;

  final UpdateAppointmentUseCase
  updateAppointmentUseCase;

  AppointmentEditBloc({
    required this.showAppointmentDetailsUseCase,
    required this.showDentistScheduleUseCase,
    required this.updateAppointmentUseCase,
  }) : super(
    const AppointmentEditInitial(),
  ) {
    on<LoadAppointmentEditRequested>(
      _onLoadAppointmentEditRequested,
    );

    on<AppointmentEditSlotSelected>(
      _onAppointmentEditSlotSelected,
    );

    on<SubmitAppointmentEditRequested>(
      _onSubmitAppointmentEditRequested,
    );
  }

  Future<void>
  _onLoadAppointmentEditRequested(
      LoadAppointmentEditRequested event,
      Emitter<AppointmentEditState> emit,
      ) async {
    emit(
      const AppointmentEditLoading(),
    );

    try {
      final appointmentResult =
      await showAppointmentDetailsUseCase(
        appointmentId:
        event.appointmentId,
        languageCode:
        event.languageCode,
      );

      final appointment =
          appointmentResult.data;

      if (appointment.dentistId <= 0) {
        emit(
          AppointmentEditError(
            message:
            _dentistUnavailableMessage(
              event.languageCode,
            ),
          ),
        );
        return;
      }

      final scheduleResult =
      await showDentistScheduleUseCase(
        dentistId:
        appointment.dentistId,
        languageCode:
        event.languageCode,
      );

      if (!scheduleResult
          .data.hasAvailableSlots) {
        emit(
          AppointmentEditEmpty(
            isFromCache:
            appointmentResult.isFromCache ||
                scheduleResult.isFromCache,
          ),
        );
        return;
      }

      emit(
        AppointmentEditLoaded(
          appointment:
          appointment,
          dentistSchedule:
          scheduleResult.data,
          appointmentFromCache:
          appointmentResult.isFromCache,
          scheduleFromCache:
          scheduleResult.isFromCache,
        ),
      );
    } catch (error) {
      emit(
        AppointmentEditError(
          message:
          _errorMessage(error),
        ),
      );
    }
  }

  void _onAppointmentEditSlotSelected(
      AppointmentEditSlotSelected event,
      Emitter<AppointmentEditState> emit,
      ) {
    final currentState = state;

    if (currentState
    is! AppointmentEditLoaded) {
      return;
    }

    final slotExists =
    currentState
        .dentistSchedule
        .days
        .any(
          (day) => day.slots.any(
            (slot) => _isSameMoment(
          slot.dateTime,
          event.appointmentTime,
        ),
      ),
    );

    if (!slotExists) {
      return;
    }

    emit(
      currentState.copyWith(
        selectedAppointmentTime:
        event.appointmentTime,
        submissionStatus:
        AppointmentEditSubmissionStatus
            .initial,
        clearSubmissionResult:
        true,
        clearSubmissionError:
        true,
      ),
    );
  }

  Future<void>
  _onSubmitAppointmentEditRequested(
      SubmitAppointmentEditRequested event,
      Emitter<AppointmentEditState> emit,
      ) async {
    final currentState = state;

    if (currentState
    is! AppointmentEditLoaded) {
      return;
    }

    final selectedAppointmentTime =
        currentState
            .selectedAppointmentTime;

    if (selectedAppointmentTime ==
        null ||
        !currentState.canSubmit) {
      return;
    }

    emit(
      currentState.copyWith(
        submissionStatus:
        AppointmentEditSubmissionStatus
            .submitting,
        clearSubmissionResult:
        true,
        clearSubmissionError:
        true,
      ),
    );

    try {
      final result =
      await updateAppointmentUseCase(
        appointmentId:
        currentState.appointment.id,
        appointmentTime:
        selectedAppointmentTime,
        notes:
        _normalizeNotes(
          event.notes,
        ),
        languageCode:
        event.languageCode,
      );

      final latestState = state;

      if (latestState
      is! AppointmentEditLoaded) {
        return;
      }

      emit(
        latestState.copyWith(
          submissionStatus:
          AppointmentEditSubmissionStatus
              .success,
          submissionResult:
          result,
          clearSubmissionError:
          true,
        ),
      );
    } catch (error) {
      final latestState = state;

      if (latestState
      is! AppointmentEditLoaded) {
        return;
      }

      emit(
        latestState.copyWith(
          submissionStatus:
          AppointmentEditSubmissionStatus
              .failure,
          clearSubmissionResult:
          true,
          submissionErrorMessage:
          _errorMessage(error),
        ),
      );
    }
  }

  String? _normalizeNotes(
      String? value,
      ) {
    final normalized =
    value?.trim();

    if (normalized == null ||
        normalized.isEmpty) {
      return null;
    }

    return normalized;
  }

  bool _isSameMoment(
      DateTime first,
      DateTime second,
      ) {
    return first.year ==
        second.year &&
        first.month ==
            second.month &&
        first.day ==
            second.day &&
        first.hour ==
            second.hour &&
        first.minute ==
            second.minute;
  }

  String _errorMessage(
      Object error,
      ) {
    return error
        .toString()
        .replaceFirst(
      'Exception: ',
      '',
    )
        .trim();
  }

  String _dentistUnavailableMessage(
      String languageCode,
      ) {
    final isArabic =
    languageCode
        .toLowerCase()
        .startsWith('ar');

    if (isArabic) {
      return 'تعذر تحديد طبيب الموعد. يرجى تحديث بيانات الموعد والمحاولة مجددًا.';
    }

    return 'Could not identify the appointment dentist. Please refresh the appointment and try again.';
  }
}