import 'dart:io';

import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile();

  Future<ProfileEntity> updateProfile(
      ProfileEntity profile, {
        File? profilePicture,
      });
}