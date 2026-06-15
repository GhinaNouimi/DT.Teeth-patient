import 'data/repositories/profile_repository_impl.dart';
import 'data/sources/profile_mock_data_source.dart';
import 'domain/usecases/get_profile_use_case.dart';
import 'domain/usecases/update_profile_use_case.dart';

abstract final class ProfileDi {
  static final ProfileMockDataSource _mockDataSource =
  ProfileMockDataSource();

  static final ProfileRepositoryImpl _repository =
  ProfileRepositoryImpl(_mockDataSource);

  static final GetProfileUseCase getProfileUseCase =
  GetProfileUseCase(_repository);

  static final UpdateProfileUseCase updateProfileUseCase =
  UpdateProfileUseCase(_repository);
}