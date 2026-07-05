import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';
import 'data/datasources/local/doctors_local_data_source.dart';
import 'data/datasources/remote/doctors_remote_data_source.dart';
import 'data/repositories/doctors_repository_impl.dart';
import 'domain/repositories/doctors_repository.dart';
import 'domain/usecases/add_dentist_rate_usecase.dart';
import 'domain/usecases/show_all_dentists_usecase.dart';
import 'domain/usecases/show_dentist_details_usecase.dart';
import 'domain/usecases/show_dentist_rate_usecase.dart';
import 'domain/usecases/show_dentists_by_specialization_usecase.dart';

abstract final class DoctorsDi {
  DoctorsDi._();

  static final NetworkInfo _networkInfo = NetworkInfo(
    connectivity: Connectivity(),
  );

  static final DoctorsRemoteDataSource _remoteDataSource =
  DoctorsRemoteDataSourceImpl(
    dio: DioClient.dio,
  );

  static const DoctorsLocalDataSource _localDataSource =
  DoctorsLocalDataSourceImpl();

  static final DoctorsRepository _repository = DoctorsRepositoryImpl(
    remoteDataSource: _remoteDataSource,
    localDataSource: _localDataSource,
    networkInfo: _networkInfo,
  );

  static final ShowAllDentistsUseCase showAllDentistsUseCase =
  ShowAllDentistsUseCase(
    repository: _repository,
  );

  static final ShowDentistDetailsUseCase showDentistDetailsUseCase =
  ShowDentistDetailsUseCase(
    repository: _repository,
  );

  static final ShowDentistsBySpecializationUseCase
  showDentistsBySpecializationUseCase =
  ShowDentistsBySpecializationUseCase(
    repository: _repository,
  );

  static final ShowDentistRateUseCase showDentistRateUseCase =
  ShowDentistRateUseCase(
    repository: _repository,
  );

  static final AddDentistRateUseCase addDentistRateUseCase =
  AddDentistRateUseCase(
    repository: _repository,
  );

  static NetworkInfo get networkInfo => _networkInfo;
}