import 'dart:convert';

import '../../../../core/cache/cache_keys.dart';
import '../../../../core/cache/cache_service.dart';
import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<void> cacheProfile(ProfileModel profile);

  Future<ProfileModel> getCachedProfile();

  Future<void> clearProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  const ProfileLocalDataSourceImpl();

  @override
  Future<void> cacheProfile(ProfileModel profile) async {
    await CacheService.saveString(
      key: CacheKeys.profile,
      value: jsonEncode(profile.toJson()),
    );
  }

  @override
  Future<ProfileModel> getCachedProfile() async {
    final cachedData = await CacheService.getString(
      key: CacheKeys.profile,
    );

    return ProfileModel.fromJson(
      jsonDecode(cachedData) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> clearProfile() async {
    await CacheService.remove(
      key: CacheKeys.profile,
    );
  }
}