import '../entities/attachment_entity.dart';
import '../repositories/medical_record_repository.dart';

class GetAttachmentsByTreatmentUseCase {
  final MedicalRecordRepository _repository;

  const GetAttachmentsByTreatmentUseCase(this._repository);

  Future<List<AttachmentEntity>> call(String treatmentId) {
    return _repository.getAttachmentsByTreatment(treatmentId);
  }
}
