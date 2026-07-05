import '../../../../core/cache/cached_result.dart';
import '../entities/dentist_details_entity.dart';
import '../repositories/doctors_repository.dart';

class ShowDentistDetailsUseCase {
  final DoctorsRepository repository;

  const ShowDentistDetailsUseCase({
    required this.repository,
  });

  Future<CachedResult<DentistDetailsEntity>> call({
    required int dentistId,
    required String languageCode,
  }) {
    return repository.showDentistDetails(
      dentistId: dentistId,
      languageCode: languageCode,
    );
  }
}