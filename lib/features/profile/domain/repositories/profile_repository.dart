import 'dart:io';

import '../../../../core/cache/cached_result.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<CachedResult<ProfileEntity>> getProfile();

  Future<ProfileEntity> updateProfile(
      ProfileEntity profile, {
        File? profilePicture,
      });
}