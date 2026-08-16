import '../../../domain/entities/appointment_action_result_entity.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/dentist_schedule_entity.dart';

enum AppointmentEditSubmissionStatus {
  initial,
  submitting,
  success,
  failure,
}

abstract class AppointmentEditState {
  const AppointmentEditState();
}

class AppointmentEditInitial
    extends AppointmentEditState {
  const AppointmentEditInitial();
}

class AppointmentEditLoading
    extends AppointmentEditState {
  const AppointmentEditLoading();
}

class AppointmentEditLoaded
    extends AppointmentEditState {
  final AppointmentEntity appointment;

  final DentistScheduleEntity dentistSchedule;

  final bool appointmentFromCache;
  final bool scheduleFromCache;

  final DateTime? selectedAppointmentTime;

  final AppointmentEditSubmissionStatus
  submissionStatus;

  final AppointmentActionResultEntity?
  submissionResult;

  final String? submissionErrorMessage;

  const AppointmentEditLoaded({
    required this.appointment,
    required this.dentistSchedule,
    required this.appointmentFromCache,
    required this.scheduleFromCache,
    this.selectedAppointmentTime,
    this.submissionStatus =
        AppointmentEditSubmissionStatus.initial,
    this.submissionResult,
    this.submissionErrorMessage,
  });

  bool get isFromCache {
    return appointmentFromCache ||
        scheduleFromCache;
  }

  bool get hasAvailableSlots {
    return dentistSchedule.hasAvailableSlots;
  }

  bool get hasSelectedAppointmentTime {
    return selectedAppointmentTime != null;
  }

  bool get isSubmitting {
    return submissionStatus ==
        AppointmentEditSubmissionStatus
            .submitting;
  }

  bool get isSubmissionSuccess {
    return submissionStatus ==
        AppointmentEditSubmissionStatus.success;
  }

  bool get isSubmissionFailure {
    return submissionStatus ==
        AppointmentEditSubmissionStatus.failure;
  }

  bool get hasChangedAppointmentTime {
    final selected =
        selectedAppointmentTime;

    if (selected == null) {
      return false;
    }

    return !_isSameMoment(
      selected,
      appointment.appointmentTime,
    );
  }

  bool get canSubmit {
    return selectedAppointmentTime != null &&
        hasChangedAppointmentTime &&
        !isSubmitting &&
        !isFromCache;
  }

  AppointmentEditLoaded copyWith({
    AppointmentEntity? appointment,
    DentistScheduleEntity? dentistSchedule,

    bool? appointmentFromCache,
    bool? scheduleFromCache,

    DateTime? selectedAppointmentTime,
    bool clearSelectedAppointmentTime = false,

    AppointmentEditSubmissionStatus?
    submissionStatus,

    AppointmentActionResultEntity?
    submissionResult,
    bool clearSubmissionResult = false,

    String? submissionErrorMessage,
    bool clearSubmissionError = false,
  }) {
    return AppointmentEditLoaded(
      appointment:
      appointment ?? this.appointment,

      dentistSchedule:
      dentistSchedule ??
          this.dentistSchedule,

      appointmentFromCache:
      appointmentFromCache ??
          this.appointmentFromCache,

      scheduleFromCache:
      scheduleFromCache ??
          this.scheduleFromCache,

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

  static bool _isSameMoment(
      DateTime first,
      DateTime second,
      ) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day &&
        first.hour == second.hour &&
        first.minute == second.minute;
  }
}

class AppointmentEditEmpty
    extends AppointmentEditState {
  final bool isFromCache;

  const AppointmentEditEmpty({
    required this.isFromCache,
  });
}

class AppointmentEditError
    extends AppointmentEditState {
  final String message;

  const AppointmentEditError({
    required this.message,
  });
}