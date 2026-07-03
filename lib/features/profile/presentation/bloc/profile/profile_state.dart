import '../../../domain/entities/profile_entity.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;

  const ProfileLoaded({
    required this.profile,
  });
}

class ProfileUpdating extends ProfileState {
  final ProfileEntity profile;

  const ProfileUpdating({
    required this.profile,
  });
}

class ProfileUpdateSuccess extends ProfileState {
  final ProfileEntity profile;

  const ProfileUpdateSuccess({
    required this.profile,
  });
}

class ProfileFailure extends ProfileState {
  final String message;

  const ProfileFailure({
    required this.message,
  });
}