import '../../../../core/cache/cached_result.dart';
import '../entities/prescription/prescription_entity.dart';

abstract class PrescriptionRepository {
  Future<CachedResult<List<PrescriptionEntity>>> getAllPrescriptions({
    required String languageCode,
  });

  Future<CachedResult<PrescriptionEntity>> getPrescriptionDetails({
    required int prescriptionId,
    required String languageCode,
  });
}