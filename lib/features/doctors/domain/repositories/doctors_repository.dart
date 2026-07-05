import '../../../../core/cache/cached_result.dart';
import '../entities/dentist_details_entity.dart';
import '../entities/dentist_entity.dart';

abstract class DoctorsRepository {
  Future<CachedResult<List<DentistEntity>>> showAllDentists({
    required String languageCode,
  });

  Future<CachedResult<DentistDetailsEntity>> showDentistDetails({
    required int dentistId,
    required String languageCode,
  });

  Future<CachedResult<List<DentistDetailsEntity>>>
  showDentistsBySpecialization({
    required int specializationId,
    required String languageCode,
  });

  Future<int> showDentistRate({
    required int dentistId,
    required String languageCode,
  });

  Future<int> addDentistRate({
    required int dentistId,
    required int rating,
    required String languageCode,
  });
}