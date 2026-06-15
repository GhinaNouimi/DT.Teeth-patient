import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';
import '../sources/profile_mock_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileMockDataSource _mockDataSource;

  const ProfileRepositoryImpl(this._mockDataSource);

  @override
  Future<ProfileEntity> getProfile() async {
    final profile = await _mockDataSource.getProfile();
    return profile.toEntity();
  }

  @override
  Future<ProfileEntity> updateProfile(ProfileEntity profile) async {
    final updatedProfile = await _mockDataSource.updateProfile(
      ProfileModel.fromEntity(profile),
    );
    return updatedProfile.toEntity();
  }
}