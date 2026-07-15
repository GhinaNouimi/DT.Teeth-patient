import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';
import 'data/datasources/local/complaints_local_data_source.dart';
import 'data/datasources/remote/complaints_remote_data_source.dart';
import 'data/repositories/complaints_repository_impl.dart';
import 'domain/usecases/add_complaint_use_case.dart';
import 'domain/usecases/get_complaints_use_case.dart';

abstract final class ComplaintsDi {
  static final ComplaintsRemoteDataSource _remoteDataSource =
  ComplaintsRemoteDataSourceImpl(
    dio: DioClient.dio,
  );

  static const ComplaintsLocalDataSource _localDataSource =
  ComplaintsLocalDataSourceImpl();

  static final NetworkInfo _networkInfo = NetworkInfo(
    connectivity: Connectivity(),
  );

  static final ComplaintsRepositoryImpl _repository =
  ComplaintsRepositoryImpl(
    remoteDataSource: _remoteDataSource,
    localDataSource: _localDataSource,
    networkInfo: _networkInfo,
  );

  static final GetComplaintsUseCase getComplaintsUseCase =
  GetComplaintsUseCase(_repository);

  static final AddComplaintUseCase addComplaintUseCase =
  AddComplaintUseCase(_repository);
}