import '../repositories/appointments_repository.dart';

class CancelAppointmentUseCase {
  final AppointmentsRepository repository;

  const CancelAppointmentUseCase({
    required this.repository,
  });

  Future<String> call({
    required int appointmentId,
    required String languageCode,
  }) {
    return repository.cancelAppointment(
      appointmentId: appointmentId,
      languageCode: languageCode,
    );
  }
}