import '../../../../core/cache/cached_result.dart';
import '../entities/dentist_details_entity.dart';
import '../repositories/doctors_repository.dart';

class ShowDentistsBySpecializationUseCase {
  final DoctorsRepository repository;

  const ShowDentistsBySpecializationUseCase({
    required this.repository,
  });

  Future<CachedResult<List<DentistDetailsEntity>>> call({
    required int specializationId,
    required String languageCode,
  }) {
    return repository.showDentistsBySpecialization(
      specializationId: specializationId,
      languageCode: languageCode,
    );
  }
}