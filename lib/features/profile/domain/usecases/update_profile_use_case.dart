import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;

  const UpdateProfileUseCase(this._repository);

  Future<ProfileEntity> call(ProfileEntity profile) {
    return _repository.updateProfile(profile);
  }
}