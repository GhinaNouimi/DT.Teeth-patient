import '../../../../core/cache/cached_result.dart';
import '../entities/treatment/treatment_entity.dart';

abstract class TreatmentRepository {
  Future<CachedResult<List<TreatmentEntity>>> getAllTreatments({
    required String languageCode,
  });

  Future<CachedResult<TreatmentEntity>> getTreatmentDetails({
    required int treatmentId,
    required String languageCode,
  });
}