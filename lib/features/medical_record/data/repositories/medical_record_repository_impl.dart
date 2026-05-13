
import '../../domain/entities/attachment_entity.dart';
import '../../domain/entities/payment_plan_entity.dart';
import '../../domain/entities/prescription_entity.dart';
import '../../domain/entities/treatment_entity.dart';
import '../../domain/repositories/medical_record_repository.dart';
import '../sources/medical_record_mock_data_source.dart';

class MedicalRecordRepositoryImpl implements MedicalRecordRepository {
  final MedicalRecordMockDataSource _dataSource;

  const MedicalRecordRepositoryImpl(this._dataSource);

  @override
  Future<List<TreatmentEntity>> getTreatments() async {
    final treatments = await _dataSource.getTreatments();
    return treatments.map((treatment) => treatment.toEntity()).toList();
  }

  @override
  Future<TreatmentEntity?> getTreatmentById(String treatmentId) async {
    final treatment = await _dataSource.getTreatmentById(treatmentId);
    return treatment?.toEntity();
  }

  @override
  Future<List<AttachmentEntity>> getAttachmentsByTreatment(
      String treatmentId,
      ) async {
    final attachments = await _dataSource.getAttachmentsByTreatment(treatmentId);
    return attachments.map((attachment) => attachment.toEntity()).toList();
  }

  @override
  Future<List<PrescriptionEntity>> getPrescriptions() async {
    final prescriptions = await _dataSource.getPrescriptions();
    return prescriptions
        .map((prescription) => prescription.toEntity())
        .toList();
  }

  @override
  Future<PrescriptionEntity?> getPrescriptionById(String prescriptionId) async {
    final prescription = await _dataSource.getPrescriptionById(prescriptionId);
    return prescription?.toEntity();
  }

  @override
  Future<PaymentPlanEntity?> getPaymentPlan() async {
    final plan = await _dataSource.getPaymentPlan();
    return plan?.toEntity();
  }
}
