import 'data/datasources/profile_remote_data_source.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/usecases/get_profile_use_case.dart';
import 'domain/usecases/update_profile_use_case.dart';

abstract final class ProfileDi {
  static final ProfileRemoteDataSource _remoteDataSource =
  ProfileRemoteDataSourceImpl();

  static final ProfileRepositoryImpl _repository = ProfileRepositoryImpl(
    remoteDataSource: _remoteDataSource,
  );

  static final GetProfileUseCase getProfileUseCase =
  GetProfileUseCase(_repository);

  static final UpdateProfileUseCase updateProfileUseCase =
  UpdateProfileUseCase(_repository);
}