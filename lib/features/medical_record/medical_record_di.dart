import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/network/network_info.dart';
import 'data/datasources/local/prescription_local_data_source.dart';
import 'data/datasources/local/prescription_local_data_source_impl.dart';
import 'data/datasources/remote/prescription_remote_data_source.dart';
import 'data/datasources/remote/prescription_remote_data_source_impl.dart';
import 'data/repositories/medical_record_repository_impl.dart';
import 'data/repositories/prescription_repository_impl.dart';
import 'data/sources/medical_record_mock_data_source.dart';
import 'domain/repositories/prescription_repository.dart';
import 'domain/usecases/get_attachments_by_treatment_use_case.dart';
import 'domain/usecases/get_payment_plan_use_case.dart';
import 'domain/usecases/get_treatment_by_id_use_case.dart';
import 'domain/usecases/get_treatments_use_case.dart';
import 'domain/usecases/prescription/get_all_prescriptions_use_case.dart';
import 'domain/usecases/prescription/get_prescription_details_use_case.dart';

abstract final class MedicalRecordDi {
  static final MedicalRecordMockDataSource _mockDataSource =
  MedicalRecordMockDataSource();

  static final MedicalRecordRepositoryImpl _medicalRecordRepository =
  MedicalRecordRepositoryImpl(_mockDataSource);

  static final GetTreatmentsUseCase getTreatmentsUseCase =
  GetTreatmentsUseCase(_medicalRecordRepository);

  static final GetTreatmentByIdUseCase getTreatmentByIdUseCase =
  GetTreatmentByIdUseCase(_medicalRecordRepository);

  static final GetAttachmentsByTreatmentUseCase
  getAttachmentsByTreatmentUseCase =
  GetAttachmentsByTreatmentUseCase(_medicalRecordRepository);

  static final GetPaymentPlanUseCase getPaymentPlanUseCase =
  GetPaymentPlanUseCase(_medicalRecordRepository);

  static final NetworkInfo _networkInfo = NetworkInfo(
    connectivity: Connectivity(),
  );

  static final PrescriptionRemoteDataSource _prescriptionRemoteDataSource =
  PrescriptionRemoteDataSourceImpl();

  static final PrescriptionLocalDataSource _prescriptionLocalDataSource =
  PrescriptionLocalDataSourceImpl();

  static final PrescriptionRepository _prescriptionRepository =
  PrescriptionRepositoryImpl(
    remoteDataSource: _prescriptionRemoteDataSource,
    localDataSource: _prescriptionLocalDataSource,
    networkInfo: _networkInfo,
  );

  static final GetAllPrescriptionsUseCase getAllPrescriptionsUseCase =
  GetAllPrescriptionsUseCase(
    repository: _prescriptionRepository,
  );

  static final GetPrescriptionDetailsUseCase getPrescriptionDetailsUseCase =
  GetPrescriptionDetailsUseCase(
    repository: _prescriptionRepository,
  );
}