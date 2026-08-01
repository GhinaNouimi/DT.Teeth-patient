import '../entities/applicable_treatment_entity.dart';
import '../repositories/offers_repository.dart';

class GetTreatmentsByTypeUseCase {
  final OffersRepository repository;

  const GetTreatmentsByTypeUseCase(this.repository);

  Future<List<ApplicableTreatmentEntity>> call({
    required int treatmentTypeId,
    required String languageCode,
  }) {
    return repository.treatmentsByType(
      treatmentTypeId: treatmentTypeId,
      languageCode: languageCode,
    );
  }
}