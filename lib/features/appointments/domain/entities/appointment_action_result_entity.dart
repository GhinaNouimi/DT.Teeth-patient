import 'appointment_entity.dart';

class AppointmentActionResultEntity {
  final String message;
  final AppointmentEntity appointment;

  const AppointmentActionResultEntity({
    required this.message,
    required this.appointment,
  });
}