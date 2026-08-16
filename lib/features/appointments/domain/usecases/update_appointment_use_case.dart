import '../entities/appointment_action_result_entity.dart';
import '../repositories/appointments_repository.dart';

class UpdateAppointmentUseCase {
  final AppointmentsRepository repository;

  const UpdateAppointmentUseCase({
    required this.repository,
  });

  Future<AppointmentActionResultEntity> call({
    required int appointmentId,
    required DateTime appointmentTime,
    String? notes,
    required String languageCode,
  }) {
    return repository.updateAppointment(
      appointmentId: appointmentId,
      appointmentTime: appointmentTime,
      notes: notes,
      languageCode: languageCode,
    );
  }
}