import '../entities/prescription_entity.dart';
import '../repositories/medical_record_repository.dart';

class GetPrescriptionsUseCase {
  final MedicalRecordRepository _repository;

  const GetPrescriptionsUseCase(this._repository);

  Future<List<PrescriptionEntity>> call() {
    return _repository.getPrescriptions();
  }
}
