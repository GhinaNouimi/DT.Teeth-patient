import '../../../../core/cache/cached_result.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointments_repository.dart';

class ShowAppointmentsUseCase {
  final AppointmentsRepository repository;

  const ShowAppointmentsUseCase({
    required this.repository,
  });

  Future<CachedResult<List<AppointmentEntity>>> call({
    required String languageCode,
  }) {
    return repository.showAppointments(
      languageCode: languageCode,
    );
  }
}