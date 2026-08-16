import '../../../../core/cache/cached_result.dart';
import '../entities/bookable_treatment_entity.dart';

abstract class BookableTreatmentsProvider {
  Future<CachedResult<List<BookableTreatmentEntity>>>
  getBookableTreatments({
    required String languageCode,
  });
}