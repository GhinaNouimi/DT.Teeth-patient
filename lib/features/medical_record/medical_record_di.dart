import 'data/repositories/medical_record_repository_impl.dart';
import 'data/sources/medical_record_mock_data_source.dart';
import 'domain/usecases/get_attachments_by_treatment_use_case.dart';
import 'domain/usecases/get_payment_plan_use_case.dart';
import 'domain/usecases/get_prescription_by_id_use_case.dart';
import 'domain/usecases/get_prescriptions_use_case.dart';
import 'domain/usecases/get_treatment_by_id_use_case.dart';
import 'domain/usecases/get_treatments_use_case.dart';

abstract final class MedicalRecordDi {
  static final MedicalRecordMockDataSource _mockDataSource =
      MedicalRecordMockDataSource();

  static final MedicalRecordRepositoryImpl _repository =
      MedicalRecordRepositoryImpl(_mockDataSource);

  static final GetTreatmentsUseCase getTreatmentsUseCase =
      GetTreatmentsUseCase(_repository);

  static final GetTreatmentByIdUseCase getTreatmentByIdUseCase =
      GetTreatmentByIdUseCase(_repository);

  static final GetAttachmentsByTreatmentUseCase getAttachmentsByTreatmentUseCase =
      GetAttachmentsByTreatmentUseCase(_repository);

  static final GetPrescriptionsUseCase getPrescriptionsUseCase =
      GetPrescriptionsUseCase(_repository);

  static final GetPrescriptionByIdUseCase getPrescriptionByIdUseCase =
      GetPrescriptionByIdUseCase(_repository);

  static final GetPaymentPlanUseCase getPaymentPlanUseCase =
      GetPaymentPlanUseCase(_repository);
}
