import 'dart:io';

import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/update_profile_request_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  const ProfileRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<ProfileEntity> getProfile() async {
    final profile = await remoteDataSource.getProfile();
    return profile.toEntity();
  }

  @override
  Future<ProfileEntity> updateProfile(
      ProfileEntity profile, {
        File? profilePicture,
      }) async {
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

    return updatedProfile.toEntity();
  }
}