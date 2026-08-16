import '../../../../core/cache/cached_result.dart';
import '../entities/dentist_schedule_entity.dart';
import '../repositories/appointments_repository.dart';

class ShowDentistScheduleUseCase {
  final AppointmentsRepository repository;

  const ShowDentistScheduleUseCase({
    required this.repository,
  });

  Future<CachedResult<DentistScheduleEntity>> call({
    required int dentistId,
    required String languageCode,
  }) {
    return repository.showDentistSchedule(
      dentistId: dentistId,
      languageCode: languageCode,
    );
  }
}