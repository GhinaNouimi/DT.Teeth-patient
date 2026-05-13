import '../entities/prescription_entity.dart';
import '../repositories/medical_record_repository.dart';

class GetPrescriptionByIdUseCase {
  final MedicalRecordRepository _repository;

  const GetPrescriptionByIdUseCase(this._repository);

  Future<PrescriptionEntity?> call(String prescriptionId) {
    return _repository.getPrescriptionById(prescriptionId);
  }
}
