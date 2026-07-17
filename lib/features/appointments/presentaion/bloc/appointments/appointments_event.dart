abstract class AppointmentsEvent {
  const AppointmentsEvent();
}

class LoadAppointmentsRequested extends AppointmentsEvent {
  final String languageCode;

  const LoadAppointmentsRequested({
    required this.languageCode,
  });
}

class RefreshAppointmentsRequested extends AppointmentsEvent {
  final String languageCode;

  const RefreshAppointmentsRequested({
    required this.languageCode,
  });
}

class CancelAppointmentRequested extends AppointmentsEvent {
  final int appointmentId;
  final String languageCode;

  const CancelAppointmentRequested({
    required this.appointmentId,
    required this.languageCode,
  });
}