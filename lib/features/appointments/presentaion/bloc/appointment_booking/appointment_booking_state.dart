import '../../../domain/entities/appointment_action_result_entity.dart';
import '../../../domain/entities/appointment_booking_dentist_entity.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/appointment_type_entity.dart';
import '../../../domain/entities/bookable_treatment_entity.dart';
import '../../../domain/entities/dentist_schedule_entity.dart';

enum AppointmentSubmissionStatus {
  initial,
  submitting,
  success,
  failure,
}

abstract class AppointmentBookingState {
  const AppointmentBookingState();
}

class AppointmentBookingInitial
    extends AppointmentBookingState {
  const AppointmentBookingInitial();
}

class AppointmentBookingLoading
    extends AppointmentBookingState {
  const AppointmentBookingLoading();
}

class AppointmentBookingLoaded
    extends AppointmentBookingState {
  final List<AppointmentTypeEntity> appointmentTypes;
  final bool appointmentTypesFromCache;

  final AppointmentBookingType? selectedBookingType;

  final List<BookableTreatmentEntity> bookableTreatments;
  final bool bookableTreatmentsFromCache;
  final bool isLoadingBookableTreatments;
  final String? bookableTreatmentsErrorMessage;
  final int? selectedTreatmentId;

  final int? selectedAppointmentTypeId;

  final List<AppointmentBookingDentistEntity> dentists;
  final bool dentistsFromCache;
  final bool isLoadingDentists;
  final String? dentistsErrorMessage;

  final int? selectedDentistId;

  final DentistScheduleEntity? dentistSchedule;
  final bool dentistScheduleFromCache;
  final bool isLoadingDentistSchedule;
  final String? dentistScheduleErrorMessage;

  final DateTime? selectedAppointmentTime;

  final AppointmentSubmissionStatus submissionStatus;
  final AppointmentActionResultEntity? submissionResult;
  final String? submissionErrorMessage;

  const AppointmentBookingLoaded({
    required this.appointmentTypes,
    required this.appointmentTypesFromCache,
    this.selectedBookingType,
    this.bookableTreatments = const [],
    this.bookableTreatmentsFromCache = false,
    this.isLoadingBookableTreatments = false,
    this.bookableTreatmentsErrorMessage,
    this.selectedTreatmentId,
    this.selectedAppointmentTypeId,
    this.dentists = const [],
    this.dentistsFromCache = false,
    this.isLoadingDentists = false,
    this.dentistsErrorMessage,
    this.selectedDentistId,
    this.dentistSchedule,
    this.dentistScheduleFromCache = false,
    this.isLoadingDentistSchedule = false,
    this.dentistScheduleErrorMessage,
    this.selectedAppointmentTime,
    this.submissionStatus =
        AppointmentSubmissionStatus.initial,
    this.submissionResult,
    this.submissionErrorMessage,
  });

  AppointmentTypeEntity? get selectedAppointmentType {
    final selectedId = selectedAppointmentTypeId;

    if (selectedId == null) {
      return null;
    }

    for (final appointmentType in appointmentTypes) {
      if (appointmentType.id == selectedId) {
        return appointmentType;
      }
    }

    return null;
  }

  BookableTreatmentEntity? get selectedTreatment {
    final selectedId = selectedTreatmentId;

    if (selectedId == null) {
      return null;
    }

    for (final treatment in bookableTreatments) {
      if (treatment.id == selectedId) {
        return treatment;
      }
    }

    return null;
  }

  AppointmentBookingDentistEntity? get selectedDentist {
    final selectedId = selectedDentistId;

    if (selectedId == null) {
      return null;
    }

    for (final dentist in dentists) {
      if (dentist.id == selectedId) {
        return dentist;
      }
    }

    return null;
  }

  String? get selectedDentistName {
    if (isContinueTreatmentBooking) {
      return selectedTreatment?.dentistName;
    }

    return selectedDentist?.name;
  }

  bool get hasSelectedBookingType {
    return selectedBookingType != null;
  }

  bool get isNewTreatmentBooking {
    return selectedBookingType ==
        AppointmentBookingType.newTreatment;
  }

  bool get isContinueTreatmentBooking {
    return selectedBookingType ==
        AppointmentBookingType.continueTreatment;
  }

  bool get isEmergencyBooking {
    return selectedBookingType ==
        AppointmentBookingType.emergency;
  }

  bool get hasBookableTreatments {
    return bookableTreatments.isNotEmpty;
  }

  bool get hasBookableTreatmentsError {
    return bookableTreatmentsErrorMessage != null &&
        bookableTreatmentsErrorMessage!
            .trim()
            .isNotEmpty;
  }

  bool get hasSelectedTreatment {
    return selectedTreatmentId != null;
  }

  bool get hasSelectedAppointmentType {
    return selectedAppointmentTypeId != null;
  }

  bool get hasDentists {
    return dentists.isNotEmpty;
  }

  bool get hasDentistsError {
    return dentistsErrorMessage != null &&
        dentistsErrorMessage!
            .trim()
            .isNotEmpty;
  }

  bool get hasSelectedDentist {
    return selectedDentistId != null;
  }

  bool get hasDentistSchedule {
    return dentistSchedule != null &&
        dentistSchedule!
            .hasAvailableSlots;
  }

  bool get hasDentistScheduleError {
    return dentistScheduleErrorMessage != null &&
        dentistScheduleErrorMessage!
            .trim()
            .isNotEmpty;
  }

  bool get hasSelectedAppointmentTime {
    return selectedAppointmentTime != null;
  }

  bool get isSubmitting {
    return submissionStatus ==
        AppointmentSubmissionStatus.submitting;
  }

  bool get isSubmissionSuccess {
    return submissionStatus ==
        AppointmentSubmissionStatus.success;
  }

  bool get isSubmissionFailure {
    return submissionStatus ==
        AppointmentSubmissionStatus.failure;
  }

  bool get hasRequiredTreatment {
    if (!isContinueTreatmentBooking) {
      return true;
    }

    return selectedTreatmentId != null;
  }

  bool get canSubmit {
    return selectedBookingType != null &&
        hasRequiredTreatment &&
        selectedAppointmentTypeId != null &&
        selectedDentistId != null &&
        selectedAppointmentTime != null &&
        !isSubmitting &&
        !isFromCache;
  }

  bool get isFromCache {
    final usesCachedTreatment =
        isContinueTreatmentBooking &&
            bookableTreatmentsFromCache;

    return appointmentTypesFromCache ||
        usesCachedTreatment ||
        dentistsFromCache ||
        dentistScheduleFromCache;
  }

  AppointmentBookingLoaded copyWith({
    List<AppointmentTypeEntity>? appointmentTypes,
    bool? appointmentTypesFromCache,

    AppointmentBookingType? selectedBookingType,
    bool clearSelectedBookingType = false,

    List<BookableTreatmentEntity>? bookableTreatments,
    bool? bookableTreatmentsFromCache,
    bool? isLoadingBookableTreatments,
    String? bookableTreatmentsErrorMessage,
    bool clearBookableTreatmentsError = false,

    int? selectedTreatmentId,
    bool clearSelectedTreatment = false,

    int? selectedAppointmentTypeId,
    bool clearSelectedAppointmentType = false,

    List<AppointmentBookingDentistEntity>? dentists,
    bool? dentistsFromCache,
    bool? isLoadingDentists,
    String? dentistsErrorMessage,
    bool clearDentistsError = false,

    int? selectedDentistId,
    bool clearSelectedDentist = false,

    DentistScheduleEntity? dentistSchedule,
    bool clearDentistSchedule = false,
    bool? dentistScheduleFromCache,
    bool? isLoadingDentistSchedule,
    String? dentistScheduleErrorMessage,
    bool clearDentistScheduleError = false,

    DateTime? selectedAppointmentTime,
    bool clearSelectedAppointmentTime = false,

    AppointmentSubmissionStatus? submissionStatus,
    AppointmentActionResultEntity? submissionResult,
    bool clearSubmissionResult = false,
    String? submissionErrorMessage,
    bool clearSubmissionError = false,
  }) {
    return AppointmentBookingLoaded(
      appointmentTypes:
      appointmentTypes ??
          this.appointmentTypes,

      appointmentTypesFromCache:
      appointmentTypesFromCache ??
          this.appointmentTypesFromCache,

      selectedBookingType:
      clearSelectedBookingType
          ? null
          : selectedBookingType ??
          this.selectedBookingType,

      bookableTreatments:
      bookableTreatments ??
          this.bookableTreatments,

      bookableTreatmentsFromCache:
      bookableTreatmentsFromCache ??
          this.bookableTreatmentsFromCache,

      isLoadingBookableTreatments:
      isLoadingBookableTreatments ??
          this.isLoadingBookableTreatments,

      bookableTreatmentsErrorMessage:
      clearBookableTreatmentsError
          ? null
          : bookableTreatmentsErrorMessage ??
          this.bookableTreatmentsErrorMessage,

      selectedTreatmentId:
      clearSelectedTreatment
          ? null
          : selectedTreatmentId ??
          this.selectedTreatmentId,

      selectedAppointmentTypeId:
      clearSelectedAppointmentType
          ? null
          : selectedAppointmentTypeId ??
          this.selectedAppointmentTypeId,

      dentists:
      dentists ??
          this.dentists,

      dentistsFromCache:
      dentistsFromCache ??
          this.dentistsFromCache,

      isLoadingDentists:
      isLoadingDentists ??
          this.isLoadingDentists,

      dentistsErrorMessage:
      clearDentistsError
          ? null
          : dentistsErrorMessage ??
          this.dentistsErrorMessage,

      selectedDentistId:
      clearSelectedDentist
          ? null
          : selectedDentistId ??
          this.selectedDentistId,

      dentistSchedule:
      clearDentistSchedule
          ? null
          : dentistSchedule ??
          this.dentistSchedule,

      dentistScheduleFromCache:
      dentistScheduleFromCache ??
          this.dentistScheduleFromCache,

      isLoadingDentistSchedule:
      isLoadingDentistSchedule ??
          this.isLoadingDentistSchedule,

      dentistScheduleErrorMessage:
      clearDentistScheduleError
          ? null
          : dentistScheduleErrorMessage ??
          this.dentistScheduleErrorMessage,

      selectedAppointmentTime:
      clearSelectedAppointmentTime
          ? null
          : selectedAppointmentTime ??
          this.selectedAppointmentTime,

      submissionStatus:
      submissionStatus ??
          this.submissionStatus,

      submissionResult:
      clearSubmissionResult
          ? null
          : submissionResult ??
          this.submissionResult,

      submissionErrorMessage:
      clearSubmissionError
          ? null
          : submissionErrorMessage ??
          this.submissionErrorMessage,
    );
  }
}

class AppointmentBookingEmpty
    extends AppointmentBookingState {
  final bool isFromCache;

  const AppointmentBookingEmpty({
    required this.isFromCache,
  });
}

class AppointmentBookingError
    extends AppointmentBookingState {
  final String message;

  const AppointmentBookingError({
    required this.message,
  });
}