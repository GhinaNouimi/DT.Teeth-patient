import '../../../../core/cache/cached_result.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointments_repository.dart';

class ShowPreviousAppointmentsUseCase {
  final AppointmentsRepository repository;

  const ShowPreviousAppointmentsUseCase({
    required this.repository,
  });

  Future<CachedResult<List<AppointmentEntity>>> call({
    required String languageCode,
  }) {
    return repository.showPreviousAppointments(
      languageCode: languageCode,
    );
  }
}