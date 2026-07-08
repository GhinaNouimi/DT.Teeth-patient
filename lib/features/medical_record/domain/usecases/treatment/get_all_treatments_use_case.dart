import '../../../../../core/cache/cached_result.dart';
import '../../entities/treatment/treatment_entity.dart';
import '../../repositories/treatment_repository.dart';

class GetAllTreatmentsUseCase {
  final TreatmentRepository repository;

  const GetAllTreatmentsUseCase({
    required this.repository,
  });

  Future<CachedResult<List<TreatmentEntity>>> call({
    required String languageCode,
  }) {
    return repository.getAllTreatments(
      languageCode: languageCode,
    );
  }
}