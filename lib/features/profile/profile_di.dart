import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../core/network/network_info.dart';
import 'data/datasources/profile_local_data_source.dart';
import 'data/datasources/profile_remote_data_source.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/usecases/get_profile_use_case.dart';
import 'domain/usecases/update_profile_use_case.dart';

abstract final class ProfileDi {
  ProfileDi._();

  static final NetworkInfo _networkInfo = NetworkInfo(
    connectivity: Connectivity(),
  );

  static const ProfileLocalDataSource _localDataSource =
  ProfileLocalDataSourceImpl();

  static final ProfileRemoteDataSource _remoteDataSource =
  ProfileRemoteDataSourceImpl();

  static final ProfileRepositoryImpl _repository = ProfileRepositoryImpl(
    remoteDataSource: _remoteDataSource,
    localDataSource: _localDataSource,
    networkInfo: _networkInfo,
  );

  static final GetProfileUseCase getProfileUseCase =
  GetProfileUseCase(_repository);

  static final UpdateProfileUseCase updateProfileUseCase =
  UpdateProfileUseCase(_repository);

  static NetworkInfo get networkInfo => _networkInfo;
}