import 'dart:io';

import '../../../../core/cache/cached_result.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/network/offline_exception.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/update_profile_request_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<CachedResult<ProfileEntity>> getProfile() async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      final profile = await remoteDataSource.getProfile();

      await localDataSource.cacheProfile(profile);

      return CachedResult.remote(profile.toEntity());
    }

    final cachedProfile = await localDataSource.getCachedProfile();

    return CachedResult.cache(cachedProfile.toEntity());
  }

  @override
  Future<ProfileEntity> updateProfile(
      ProfileEntity profile, {
        File? profilePicture,
      }) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      throw const OfflineException();
    }

    final updatedProfile = await remoteDataSource.updateProfile(
      UpdateProfileRequestModel(
        name: profile.name,
        phone: profile.phone,
        dateOfBirth: profile.dateOfBirth,
        gender: profile.gender,
        address: profile.address,
        emergencyContactName: profile.emergencyContactName,
        emergencyContactRelation: profile.emergencyContactRelation,
        emergencyContactPhone: profile.emergencyContactPhone,
        isPregnant: profile.isPregnant,
        isBreastfeeding: profile.isBreastfeeding,
        isSmoker: profile.isSmoker,
        drinksAlcoholFrequently: profile.drinksAlcoholFrequently,
        teethCleaningFrequency: profile.teethCleaningFrequency,
        profilePicture: profilePicture,
      ),
    );

    await localDataSource.cacheProfile(updatedProfile);

    return updatedProfile.toEntity();
  }
}