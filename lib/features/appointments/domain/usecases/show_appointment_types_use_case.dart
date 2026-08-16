import '../../../../core/cache/cached_result.dart';
import '../entities/appointment_type_entity.dart';
import '../repositories/appointments_repository.dart';

class ShowAppointmentTypesUseCase {
  final AppointmentsRepository repository;

  const ShowAppointmentTypesUseCase({
    required this.repository,
  });

  Future<CachedResult<List<AppointmentTypeEntity>>> call({
    required String languageCode,
  }) {
    return repository.showAppointmentTypes(
      languageCode: languageCode,
    );
  }
}