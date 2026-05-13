import '../entities/treatment_entity.dart';
import '../repositories/medical_record_repository.dart';

class GetTreatmentsUseCase {
  final MedicalRecordRepository _repository;

  const GetTreatmentsUseCase(this._repository);

  Future<List<TreatmentEntity>> call() {
    return _repository.getTreatments();
  }
}
