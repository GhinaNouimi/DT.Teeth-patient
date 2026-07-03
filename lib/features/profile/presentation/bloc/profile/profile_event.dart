import 'dart:io';

import '../../../domain/entities/profile_entity.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class LoadProfileRequested extends ProfileEvent {
  final String languageCode;

  const LoadProfileRequested({
    required this.languageCode,
  });
}

class UpdateProfileRequested extends ProfileEvent {
  final ProfileEntity profile;
  final File? profilePicture;
  final String languageCode;

  const UpdateProfileRequested({
    required this.profile,
    this.profilePicture,
    required this.languageCode,
  });
}