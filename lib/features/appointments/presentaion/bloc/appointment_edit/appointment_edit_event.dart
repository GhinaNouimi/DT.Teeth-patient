abstract class AppointmentEditEvent {
  const AppointmentEditEvent();
}

class LoadAppointmentEditRequested
    extends AppointmentEditEvent {
  final int appointmentId;
  final String languageCode;

  const LoadAppointmentEditRequested({
    required this.appointmentId,
    required this.languageCode,
  });
}

class AppointmentEditSlotSelected
    extends AppointmentEditEvent {
  final DateTime appointmentTime;

  const AppointmentEditSlotSelected({
    required this.appointmentTime,
  });
}

class SubmitAppointmentEditRequested
    extends AppointmentEditEvent {
  final String? notes;
  final String languageCode;

  const SubmitAppointmentEditRequested({
    this.notes,
    required this.languageCode,
  });
}