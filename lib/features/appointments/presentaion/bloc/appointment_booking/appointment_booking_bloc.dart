import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/usecases/add_appointment_use_case.dart';
import '../../../domain/usecases/get_bookable_treatments_use_case.dart';
import '../../../domain/usecases/show_appointment_types_use_case.dart';
import '../../../domain/usecases/show_dentist_schedule_use_case.dart';
import '../../../domain/usecases/show_dentists_by_appointment_type_use_case.dart';
import 'appointment_booking_event.dart';
import 'appointment_booking_state.dart';

class AppointmentBookingBloc extends Bloc<
    AppointmentBookingEvent,
    AppointmentBookingState> {
  final ShowAppointmentTypesUseCase
  showAppointmentTypesUseCase;

  final ShowDentistsByAppointmentTypeUseCase
  showDentistsByAppointmentTypeUseCase;

  final ShowDentistScheduleUseCase
  showDentistScheduleUseCase;

  final GetBookableTreatmentsUseCase
  getBookableTreatmentsUseCase;

  final AddAppointmentUseCase
  addAppointmentUseCase;

  AppointmentBookingBloc({
    required this.showAppointmentTypesUseCase,
    required this.showDentistsByAppointmentTypeUseCase,
    required this.showDentistScheduleUseCase,
    required this.getBookableTreatmentsUseCase,
    required this.addAppointmentUseCase,
  }) : super(
    const AppointmentBookingInitial(),
  ) {
    on<LoadAppointmentTypesRequested>(
      _onLoadAppointmentTypesRequested,
    );

    on<AppointmentBookingTypeSelected>(
      _onAppointmentBookingTypeSelected,
    );

    on<AppointmentTreatmentSelected>(
      _onAppointmentTreatmentSelected,
    );

    on<AppointmentTypeSelected>(
      _onAppointmentTypeSelected,
    );

    on<AppointmentDentistSelected>(
      _onAppointmentDentistSelected,
    );

    on<AppointmentSlotSelected>(
      _onAppointmentSlotSelected,
    );

    on<AddAppointmentRequested>(
      _onAddAppointmentRequested,
    );
  }

  Future<void> _onLoadAppointmentTypesRequested(
      LoadAppointmentTypesRequested event,
      Emitter<AppointmentBookingState> emit,
      ) async {
    emit(
      const AppointmentBookingLoading(),
    );

    try {
      final result =
      await showAppointmentTypesUseCase(
        languageCode: event.languageCode,
      );

      if (result.data.isEmpty) {
        emit(
          AppointmentBookingEmpty(
            isFromCache: result.isFromCache,
          ),
        );

        return;
      }

      emit(
        AppointmentBookingLoaded(
          appointmentTypes: result.data,
          appointmentTypesFromCache:
          result.isFromCache,
        ),
      );
    } catch (error) {
      emit(
        AppointmentBookingError(
          message: _errorMessage(error),
        ),
      );
    }
  }

  Future<void> _onAppointmentBookingTypeSelected(
      AppointmentBookingTypeSelected event,
      Emitter<AppointmentBookingState> emit,
      ) async {
    final currentState = state;

    if (currentState
    is! AppointmentBookingLoaded) {
      return;
    }

    if (!_isPatientSupportedBookingType(
      event.bookingType,
    )) {
      return;
    }

    final isContinueTreatment =
        event.bookingType ==
            AppointmentBookingType
                .continueTreatment;

    emit(
      currentState.copyWith(
        selectedBookingType:
        event.bookingType,

        bookableTreatments:
        const [],
        bookableTreatmentsFromCache:
        false,
        isLoadingBookableTreatments:
        isContinueTreatment,
        clearBookableTreatmentsError:
        true,
        clearSelectedTreatment:
        true,

        clearSelectedAppointmentType:
        true,

        dentists:
        const [],
        dentistsFromCache:
        false,
        isLoadingDentists:
        false,
        clearDentistsError:
        true,

        clearSelectedDentist:
        true,

        clearDentistSchedule:
        true,
        dentistScheduleFromCache:
        false,
        isLoadingDentistSchedule:
        false,
        clearDentistScheduleError:
        true,

        clearSelectedAppointmentTime:
        true,

        submissionStatus:
        AppointmentSubmissionStatus
            .initial,
        clearSubmissionResult:
        true,
        clearSubmissionError:
        true,
      ),
    );

    if (!isContinueTreatment) {
      return;
    }

    try {
      final result =
      await getBookableTreatmentsUseCase(
        languageCode:
        event.languageCode,
      );

      final latestState =
          state;

      if (latestState
      is! AppointmentBookingLoaded ||
          latestState.selectedBookingType !=
              AppointmentBookingType
                  .continueTreatment) {
        return;
      }

      emit(
        latestState.copyWith(
          bookableTreatments:
          result.data,
          bookableTreatmentsFromCache:
          result.isFromCache,
          isLoadingBookableTreatments:
          false,
          clearBookableTreatmentsError:
          true,
        ),
      );
    } catch (error) {
      final latestState =
          state;

      if (latestState
      is! AppointmentBookingLoaded ||
          latestState.selectedBookingType !=
              AppointmentBookingType
                  .continueTreatment) {
        return;
      }

      emit(
        latestState.copyWith(
          bookableTreatments:
          const [],
          bookableTreatmentsFromCache:
          false,
          isLoadingBookableTreatments:
          false,
          bookableTreatmentsErrorMessage:
          _errorMessage(error),
        ),
      );
    }
  }

  void _onAppointmentTreatmentSelected(
      AppointmentTreatmentSelected event,
      Emitter<AppointmentBookingState> emit,
      ) {
    final currentState = state;

    if (currentState
    is! AppointmentBookingLoaded ||
        !currentState
            .isContinueTreatmentBooking) {
      return;
    }

    final selectedTreatment =
        currentState.bookableTreatments
            .where(
              (treatment) =>
          treatment.id ==
              event.treatmentId,
        )
            .firstOrNull;

    if (selectedTreatment == null) {
      return;
    }

    emit(
      currentState.copyWith(
        selectedTreatmentId:
        selectedTreatment.id,

        // الطبيب محسوم من العلاج نفسه.
        selectedDentistId:
        selectedTreatment.dentistId,

        clearSelectedAppointmentType:
        true,

        // لا نحتاج قائمة أطباء في متابعة العلاج.
        dentists:
        const [],
        dentistsFromCache:
        false,
        isLoadingDentists:
        false,
        clearDentistsError:
        true,

        clearDentistSchedule:
        true,
        dentistScheduleFromCache:
        false,
        isLoadingDentistSchedule:
        false,
        clearDentistScheduleError:
        true,

        clearSelectedAppointmentTime:
        true,

        submissionStatus:
        AppointmentSubmissionStatus
            .initial,
        clearSubmissionResult:
        true,
        clearSubmissionError:
        true,
      ),
    );
  }

  Future<void> _onAppointmentTypeSelected(
      AppointmentTypeSelected event,
      Emitter<AppointmentBookingState> emit,
      ) async {
    final currentState = state;

    if (currentState
    is! AppointmentBookingLoaded) {
      return;
    }

    if (!currentState
        .hasSelectedBookingType) {
      return;
    }

    if (currentState
        .isContinueTreatmentBooking &&
        !currentState
            .hasSelectedTreatment) {
      return;
    }

    final typeExists =
    currentState.appointmentTypes.any(
          (appointmentType) =>
      appointmentType.id ==
          event.appointmentTypeId,
    );

    if (!typeExists) {
      return;
    }

    /*
     * متابعة علاج:
     * الطبيب معروف من العلاج.
     * لا نستدعي showDentistsByAppointmentType.
     * نحمّل جدول الطبيب مباشرة.
     */
    if (currentState
        .isContinueTreatmentBooking) {
      final dentistId =
          currentState.selectedDentistId;

      if (dentistId == null ||
          dentistId <= 0) {
        return;
      }

      emit(
        currentState.copyWith(
          selectedAppointmentTypeId:
          event.appointmentTypeId,

          dentists:
          const [],
          dentistsFromCache:
          false,
          isLoadingDentists:
          false,
          clearDentistsError:
          true,

          clearDentistSchedule:
          true,
          dentistScheduleFromCache:
          false,
          isLoadingDentistSchedule:
          true,
          clearDentistScheduleError:
          true,

          clearSelectedAppointmentTime:
          true,

          submissionStatus:
          AppointmentSubmissionStatus
              .initial,
          clearSubmissionResult:
          true,
          clearSubmissionError:
          true,
        ),
      );

      await _loadContinueTreatmentSchedule(
        dentistId:
        dentistId,
        languageCode:
        event.languageCode,
        appointmentTypeId:
        event.appointmentTypeId,
        emit:
        emit,
      );

      return;
    }

    /*
     * علاج جديد / طارئ:
     * يبقى الـFlow الحالي:
     * نوع الموعد → الأطباء → الطبيب → الجدول.
     */

    emit(
      currentState.copyWith(
        selectedAppointmentTypeId:
        event.appointmentTypeId,

        dentists:
        const [],
        dentistsFromCache:
        false,
        isLoadingDentists:
        true,
        clearDentistsError:
        true,

        clearSelectedDentist:
        true,

        clearDentistSchedule:
        true,
        dentistScheduleFromCache:
        false,
        isLoadingDentistSchedule:
        false,
        clearDentistScheduleError:
        true,

        clearSelectedAppointmentTime:
        true,

        submissionStatus:
        AppointmentSubmissionStatus
            .initial,
        clearSubmissionResult:
        true,
        clearSubmissionError:
        true,
      ),
    );

    try {
      final result =
      await showDentistsByAppointmentTypeUseCase(
        appointmentTypeId:
        event.appointmentTypeId,
        languageCode:
        event.languageCode,
      );

      final latestState =
          state;

      if (latestState
      is! AppointmentBookingLoaded ||
          latestState
              .selectedAppointmentTypeId !=
              event.appointmentTypeId ||
          latestState
              .isContinueTreatmentBooking) {
        return;
      }

      emit(
        latestState.copyWith(
          dentists:
          result.data,
          dentistsFromCache:
          result.isFromCache,
          isLoadingDentists:
          false,
          clearDentistsError:
          true,
        ),
      );
    } catch (error) {
      final latestState =
          state;

      if (latestState
      is! AppointmentBookingLoaded ||
          latestState
              .selectedAppointmentTypeId !=
              event.appointmentTypeId ||
          latestState
              .isContinueTreatmentBooking) {
        return;
      }

      emit(
        latestState.copyWith(
          dentists:
          const [],
          dentistsFromCache:
          false,
          isLoadingDentists:
          false,
          dentistsErrorMessage:
          _errorMessage(error),
        ),
      );
    }
  }

  Future<void> _loadContinueTreatmentSchedule({
    required int dentistId,
    required int appointmentTypeId,
    required String languageCode,
    required Emitter<AppointmentBookingState> emit,
  }) async {
    try {
      final result =
      await showDentistScheduleUseCase(
        dentistId:
        dentistId,
        languageCode:
        languageCode,
      );

      final latestState =
          state;

      if (latestState
      is! AppointmentBookingLoaded ||
          !latestState
              .isContinueTreatmentBooking ||
          latestState.selectedDentistId !=
              dentistId ||
          latestState
              .selectedAppointmentTypeId !=
              appointmentTypeId) {
        return;
      }

      emit(
        latestState.copyWith(
          dentistSchedule:
          result.data,
          dentistScheduleFromCache:
          result.isFromCache,
          isLoadingDentistSchedule:
          false,
          clearDentistScheduleError:
          true,
        ),
      );
    } catch (error) {
      final latestState =
          state;

      if (latestState
      is! AppointmentBookingLoaded ||
          !latestState
              .isContinueTreatmentBooking ||
          latestState.selectedDentistId !=
              dentistId ||
          latestState
              .selectedAppointmentTypeId !=
              appointmentTypeId) {
        return;
      }

      emit(
        latestState.copyWith(
          clearDentistSchedule:
          true,
          dentistScheduleFromCache:
          false,
          isLoadingDentistSchedule:
          false,
          dentistScheduleErrorMessage:
          _errorMessage(error),
        ),
      );
    }
  }

  Future<void> _onAppointmentDentistSelected(
      AppointmentDentistSelected event,
      Emitter<AppointmentBookingState> emit,
      ) async {
    final currentState = state;

    if (currentState
    is! AppointmentBookingLoaded) {
      return;
    }

    // متابعة العلاج لا تسمح بتغيير الطبيب.
    if (currentState
        .isContinueTreatmentBooking) {
      return;
    }

    final dentistExists =
    currentState.dentists.any(
          (dentist) =>
      dentist.id ==
          event.dentistId,
    );

    if (!dentistExists) {
      return;
    }

    emit(
      currentState.copyWith(
        selectedDentistId:
        event.dentistId,

        clearDentistSchedule:
        true,
        dentistScheduleFromCache:
        false,
        isLoadingDentistSchedule:
        true,
        clearDentistScheduleError:
        true,

        clearSelectedAppointmentTime:
        true,

        submissionStatus:
        AppointmentSubmissionStatus
            .initial,
        clearSubmissionResult:
        true,
        clearSubmissionError:
        true,
      ),
    );

    try {
      final result =
      await showDentistScheduleUseCase(
        dentistId:
        event.dentistId,
        languageCode:
        event.languageCode,
      );

      final latestState =
          state;

      if (latestState
      is! AppointmentBookingLoaded ||
          latestState.selectedDentistId !=
              event.dentistId) {
        return;
      }

      emit(
        latestState.copyWith(
          dentistSchedule:
          result.data,
          dentistScheduleFromCache:
          result.isFromCache,
          isLoadingDentistSchedule:
          false,
          clearDentistScheduleError:
          true,
        ),
      );
    } catch (error) {
      final latestState =
          state;

      if (latestState
      is! AppointmentBookingLoaded ||
          latestState.selectedDentistId !=
              event.dentistId) {
        return;
      }

      emit(
        latestState.copyWith(
          clearDentistSchedule:
          true,
          dentistScheduleFromCache:
          false,
          isLoadingDentistSchedule:
          false,
          dentistScheduleErrorMessage:
          _errorMessage(error),
        ),
      );
    }
  }

  void _onAppointmentSlotSelected(
      AppointmentSlotSelected event,
      Emitter<AppointmentBookingState> emit,
      ) {
    final currentState = state;

    if (currentState
    is! AppointmentBookingLoaded) {
      return;
    }

    final schedule =
        currentState.dentistSchedule;

    if (schedule == null) {
      return;
    }

    final slotExists =
    schedule.days.any(
          (day) => day.slots.any(
            (slot) =>
            _isSameAppointmentTime(
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
        AppointmentSubmissionStatus
            .initial,
        clearSubmissionResult:
        true,
        clearSubmissionError:
        true,
      ),
    );
  }

  Future<void> _onAddAppointmentRequested(
      AddAppointmentRequested event,
      Emitter<AppointmentBookingState> emit,
      ) async {
    final currentState = state;

    if (currentState
    is! AppointmentBookingLoaded) {
      return;
    }

    final bookingType =
        currentState.selectedBookingType;

    final treatmentId =
        currentState.selectedTreatmentId;

    final appointmentTypeId =
        currentState
            .selectedAppointmentTypeId;

    final dentistId =
        currentState.selectedDentistId;

    final appointmentTime =
        currentState.selectedAppointmentTime;

    if (bookingType == null ||
        appointmentTypeId == null ||
        dentistId == null ||
        appointmentTime == null ||
        currentState.isSubmitting ||
        currentState.isFromCache) {
      return;
    }

    if (bookingType ==
        AppointmentBookingType
            .continueTreatment &&
        treatmentId == null) {
      return;
    }

    emit(
      currentState.copyWith(
        submissionStatus:
        AppointmentSubmissionStatus
            .submitting,
        clearSubmissionResult:
        true,
        clearSubmissionError:
        true,
      ),
    );

    try {
      final result =
      await addAppointmentUseCase(
        dentistId:
        dentistId,
        appointmentTypeId:
        appointmentTypeId,
        appointmentTime:
        appointmentTime,
        type:
        bookingType,
        treatmentId:
        treatmentId,
        notes:
        event.notes,
        languageCode:
        event.languageCode,
      );

      final latestState =
          state;

      if (latestState
      is! AppointmentBookingLoaded) {
        return;
      }

      emit(
        latestState.copyWith(
          submissionStatus:
          AppointmentSubmissionStatus
              .success,
          submissionResult:
          result,
          clearSubmissionError:
          true,
        ),
      );
    } catch (error) {
      final latestState =
          state;

      if (latestState
      is! AppointmentBookingLoaded) {
        return;
      }

      emit(
        latestState.copyWith(
          submissionStatus:
          AppointmentSubmissionStatus
              .failure,
          clearSubmissionResult:
          true,
          submissionErrorMessage:
          _errorMessage(error),
        ),
      );
    }
  }

  bool _isPatientSupportedBookingType(
      AppointmentBookingType type,
      ) {
    return type ==
        AppointmentBookingType
            .newTreatment ||
        type ==
            AppointmentBookingType
                .continueTreatment ||
        type ==
            AppointmentBookingType
                .emergency;
  }

  bool _isSameAppointmentTime(
      DateTime first,
      DateTime second,
      ) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day &&
        first.hour == second.hour &&
        first.minute == second.minute;
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
}