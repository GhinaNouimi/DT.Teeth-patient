import '../../../../../core/cache/cached_result.dart';
import '../../entities/prescription/prescription_entity.dart';
import '../../repositories/prescription_repository.dart';

class GetAllPrescriptionsUseCase {
  final PrescriptionRepository repository;

  const GetAllPrescriptionsUseCase({
    required this.repository,
  });

  Future<CachedResult<List<PrescriptionEntity>>> call({
    required String languageCode,
  }) {
    return repository.getAllPrescriptions(
      languageCode: languageCode,
    );
  }
}