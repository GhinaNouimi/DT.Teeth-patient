import '../../../domain/entities/appointment_entity.dart';

abstract class AppointmentBookingEvent {
  const AppointmentBookingEvent();
}

class LoadAppointmentTypesRequested
    extends AppointmentBookingEvent {
  final String languageCode;

  const LoadAppointmentTypesRequested({
    required this.languageCode,
  });
}

class AppointmentBookingTypeSelected
    extends AppointmentBookingEvent {
  final AppointmentBookingType bookingType;
  final String languageCode;

  const AppointmentBookingTypeSelected({
    required this.bookingType,
    required this.languageCode,
  });
}

class AppointmentTreatmentSelected
    extends AppointmentBookingEvent {
  final int treatmentId;

  const AppointmentTreatmentSelected({
    required this.treatmentId,
  });
}

class AppointmentTypeSelected
    extends AppointmentBookingEvent {
  final int appointmentTypeId;
  final String languageCode;

  const AppointmentTypeSelected({
    required this.appointmentTypeId,
    required this.languageCode,
  });
}

class AppointmentDentistSelected
    extends AppointmentBookingEvent {
  final int dentistId;
  final String languageCode;

  const AppointmentDentistSelected({
    required this.dentistId,
    required this.languageCode,
  });
}

class AppointmentSlotSelected
    extends AppointmentBookingEvent {
  final DateTime appointmentTime;

  const AppointmentSlotSelected({
    required this.appointmentTime,
  });
}

class AddAppointmentRequested
    extends AppointmentBookingEvent {
  final String? notes;
  final String languageCode;

  const AddAppointmentRequested({
    this.notes,
    required this.languageCode,
  });
}