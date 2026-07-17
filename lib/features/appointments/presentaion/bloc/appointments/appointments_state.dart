import '../../../domain/entities/appointment_entity.dart';

abstract class AppointmentsState {
  const AppointmentsState();
}

class AppointmentsInitial extends AppointmentsState {
  const AppointmentsInitial();
}

class AppointmentsLoading extends AppointmentsState {
  const AppointmentsLoading();
}

class AppointmentsLoaded extends AppointmentsState {
  final List<AppointmentEntity> upcomingAppointments;
  final List<AppointmentEntity> pastAppointments;

  final bool isUpcomingFromCache;
  final bool isPastFromCache;

  final int? cancellingAppointmentId;

  const AppointmentsLoaded({
    required this.upcomingAppointments,
    required this.pastAppointments,
    required this.isUpcomingFromCache,
    required this.isPastFromCache,
    this.cancellingAppointmentId,
  });

  bool get isFromCache =>
      isUpcomingFromCache || isPastFromCache;

  AppointmentsLoaded copyWith({
    List<AppointmentEntity>? upcomingAppointments,
    List<AppointmentEntity>? pastAppointments,
    bool? isUpcomingFromCache,
    bool? isPastFromCache,
    int? cancellingAppointmentId,
    bool clearCancellingAppointmentId = false,
  }) {
    return AppointmentsLoaded(
      upcomingAppointments:
      upcomingAppointments ?? this.upcomingAppointments,
      pastAppointments:
      pastAppointments ?? this.pastAppointments,
      isUpcomingFromCache:
      isUpcomingFromCache ?? this.isUpcomingFromCache,
      isPastFromCache:
      isPastFromCache ?? this.isPastFromCache,
      cancellingAppointmentId:
      clearCancellingAppointmentId
          ? null
          : cancellingAppointmentId ??
          this.cancellingAppointmentId,
    );
  }
}

class AppointmentsRefreshFailure extends AppointmentsLoaded {
  final String message;

  const AppointmentsRefreshFailure({
    required super.upcomingAppointments,
    required super.pastAppointments,
    required super.isUpcomingFromCache,
    required super.isPastFromCache,
    required this.message,
  });
}

class AppointmentCancellationSuccess
    extends AppointmentsLoaded {
  final String message;

  const AppointmentCancellationSuccess({
    required super.upcomingAppointments,
    required super.pastAppointments,
    required super.isUpcomingFromCache,
    required super.isPastFromCache,
    required this.message,
  });
}

class AppointmentCancellationFailure
    extends AppointmentsLoaded {
  final String message;

  const AppointmentCancellationFailure({
    required super.upcomingAppointments,
    required super.pastAppointments,
    required super.isUpcomingFromCache,
    required super.isPastFromCache,
    required this.message,
  });
}

class AppointmentsError extends AppointmentsState {
  final String message;

  const AppointmentsError({
    required this.message,
  });
}