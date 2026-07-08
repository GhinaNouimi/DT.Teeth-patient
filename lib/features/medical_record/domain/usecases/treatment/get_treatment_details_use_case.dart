import '../../../../../core/cache/cached_result.dart';
import '../../entities/treatment/treatment_entity.dart';
import '../../repositories/treatment_repository.dart';

class GetTreatmentDetailsUseCase {
  final TreatmentRepository repository;

  const GetTreatmentDetailsUseCase({
    required this.repository,
  });

  Future<CachedResult<TreatmentEntity>> call({
    required int treatmentId,
    required String languageCode,
  }) {
    return repository.getTreatmentDetails(
      treatmentId: treatmentId,
      languageCode: languageCode,
    );
  }
}