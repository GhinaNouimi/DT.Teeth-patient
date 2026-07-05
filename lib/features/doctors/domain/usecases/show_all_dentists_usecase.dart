import '../../../../core/cache/cached_result.dart';
import '../entities/dentist_entity.dart';
import '../repositories/doctors_repository.dart';

class ShowAllDentistsUseCase {
  final DoctorsRepository repository;

  const ShowAllDentistsUseCase({
    required this.repository,
  });

  Future<CachedResult<List<DentistEntity>>> call({
    required String languageCode,
  }) {
    return repository.showAllDentists(
      languageCode: languageCode,
    );
  }
}