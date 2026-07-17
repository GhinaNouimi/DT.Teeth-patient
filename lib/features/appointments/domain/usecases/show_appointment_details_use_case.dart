import '../../../../core/cache/cached_result.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointments_repository.dart';

class ShowAppointmentDetailsUseCase {
  final AppointmentsRepository repository;

  const ShowAppointmentDetailsUseCase({
    required this.repository,
  });

  Future<CachedResult<AppointmentEntity>> call({
    required int appointmentId,
    required String languageCode,
  }) {
    return repository.showAppointmentDetails(
      appointmentId: appointmentId,
      languageCode: languageCode,
    );
  }
}