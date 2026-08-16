import '../entities/appointment_action_result_entity.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointments_repository.dart';

class AddAppointmentUseCase {
  final AppointmentsRepository repository;

  const AddAppointmentUseCase({
    required this.repository,
  });

  Future<AppointmentActionResultEntity> call({
    required int dentistId,
    required int appointmentTypeId,
    required DateTime appointmentTime,
    required AppointmentBookingType type,
    int? treatmentId,
    String? notes,
    required String languageCode,
  }) {
    return repository.addAppointment(
      dentistId: dentistId,
      appointmentTypeId: appointmentTypeId,
      appointmentTime: appointmentTime,
      type: type,
      treatmentId: treatmentId,
      notes: notes,
      languageCode: languageCode,
    );
  }
}