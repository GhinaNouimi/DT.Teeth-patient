import '../../../../../core/cache/cached_result.dart';
import '../../entities/prescription/prescription_entity.dart';
import '../../repositories/prescription_repository.dart';

class GetPrescriptionDetailsUseCase {
  final PrescriptionRepository repository;

  const GetPrescriptionDetailsUseCase({
    required this.repository,
  });

  Future<CachedResult<PrescriptionEntity>> call({
    required int prescriptionId,
    required String languageCode,
  }) {
    return repository.getPrescriptionDetails(
      prescriptionId: prescriptionId,
      languageCode: languageCode,
    );
  }
}