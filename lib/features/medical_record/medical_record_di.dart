import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/network/network_info.dart';
import 'data/datasources/local/prescription_local_data_source.dart';
import 'data/datasources/local/prescription_local_data_source_impl.dart';
import 'data/datasources/local/treatment_local_data_source.dart';
import 'data/datasources/local/treatment_local_data_source_impl.dart';
import 'data/datasources/remote/prescription_remote_data_source.dart';
import 'data/datasources/remote/prescription_remote_data_source_impl.dart';
import 'data/datasources/remote/treatment_remote_data_source.dart';
import 'data/datasources/remote/treatment_remote_data_source_impl.dart';
import 'data/repositories/prescription_repository_impl.dart';
import 'data/repositories/treatment_repository_impl.dart';
import 'domain/repositories/prescription_repository.dart';
import 'domain/repositories/treatment_repository.dart';
import 'domain/usecases/prescription/get_all_prescriptions_use_case.dart';
import 'domain/usecases/prescription/get_prescription_details_use_case.dart';
import 'domain/usecases/treatment/get_all_treatments_use_case.dart';
import 'domain/usecases/treatment/get_treatment_details_use_case.dart';

abstract final class MedicalRecordDi {
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

  static final TreatmentRemoteDataSource _treatmentRemoteDataSource =
  TreatmentRemoteDataSourceImpl();

  static final TreatmentLocalDataSource _treatmentLocalDataSource =
  TreatmentLocalDataSourceImpl();

  static final TreatmentRepository _treatmentRepository =
  TreatmentRepositoryImpl(
    remoteDataSource: _treatmentRemoteDataSource,
    localDataSource: _treatmentLocalDataSource,
    networkInfo: _networkInfo,
  );

  static final GetAllTreatmentsUseCase getAllTreatmentsUseCase =
  GetAllTreatmentsUseCase(
    repository: _treatmentRepository,
  );

  static final GetTreatmentDetailsUseCase getTreatmentDetailsUseCase =
  GetTreatmentDetailsUseCase(
    repository: _treatmentRepository,
  );
}