import '../entities/attachment_entity.dart';
import '../entities/payment_plan_entity.dart';
import '../entities/prescription_entity.dart';
import '../entities/treatment_entity.dart';

abstract class MedicalRecordRepository {
  Future<List<TreatmentEntity>> getTreatments();

  Future<TreatmentEntity?> getTreatmentById(String treatmentId);

  Future<List<AttachmentEntity>> getAttachmentsByTreatment(String treatmentId);

  Future<List<PrescriptionEntity>> getPrescriptions();

  Future<PrescriptionEntity?> getPrescriptionById(String prescriptionId);

  Future<PaymentPlanEntity?> getPaymentPlan();
}
