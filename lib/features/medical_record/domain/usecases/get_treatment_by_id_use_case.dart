import '../entities/treatment_entity.dart';
import '../repositories/medical_record_repository.dart';

class GetTreatmentByIdUseCase {
  final MedicalRecordRepository _repository;

  const GetTreatmentByIdUseCase(this._repository);

  Future<TreatmentEntity?> call(String treatmentId) {
    return _repository.getTreatmentById(treatmentId);
  }
}
