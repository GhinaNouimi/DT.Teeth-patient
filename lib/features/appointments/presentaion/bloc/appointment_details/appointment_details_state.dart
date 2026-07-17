import '../../../domain/entities/appointment_entity.dart';

abstract class AppointmentDetailsState {
  const AppointmentDetailsState();
}

class AppointmentDetailsInitial
    extends AppointmentDetailsState {
  const AppointmentDetailsInitial();
}

class AppointmentDetailsLoading
    extends AppointmentDetailsState {
  const AppointmentDetailsLoading();
}

class AppointmentDetailsLoaded
    extends AppointmentDetailsState {
  final AppointmentEntity appointment;
  final bool isFromCache;

  const AppointmentDetailsLoaded({
    required this.appointment,
    required this.isFromCache,
  });
}

class AppointmentDetailsError
    extends AppointmentDetailsState {
  final String message;

  const AppointmentDetailsError({
    required this.message,
  });
}

class AppointmentDetailsCancellationInProgress
    extends AppointmentDetailsState {
  final AppointmentEntity appointment;
  final bool isFromCache;

  const AppointmentDetailsCancellationInProgress({
    required this.appointment,
    required this.isFromCache,
  });
}

class AppointmentDetailsCancellationSuccess
    extends AppointmentDetailsState {
  final AppointmentEntity appointment;
  final bool isFromCache;
  final String message;

  const AppointmentDetailsCancellationSuccess({
    required this.appointment,
    required this.isFromCache,
    required this.message,
  });
}

class AppointmentDetailsCancellationFailure
    extends AppointmentDetailsState {
  final AppointmentEntity appointment;
  final bool isFromCache;
  final String message;

  const AppointmentDetailsCancellationFailure({
    required this.appointment,
    required this.isFromCache,
    required this.message,
  });
}