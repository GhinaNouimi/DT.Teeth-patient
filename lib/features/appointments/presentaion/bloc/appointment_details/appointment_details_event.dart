abstract class AppointmentDetailsEvent {
  const AppointmentDetailsEvent();
}

class LoadAppointmentDetailsRequested
    extends AppointmentDetailsEvent {
  final int appointmentId;
  final String languageCode;

  const LoadAppointmentDetailsRequested({
    required this.appointmentId,
    required this.languageCode,
  });
}

class CancelAppointmentFromDetailsRequested
    extends AppointmentDetailsEvent {
  final int appointmentId;
  final String languageCode;

  const CancelAppointmentFromDetailsRequested({
    required this.appointmentId,
    required this.languageCode,
  });
}