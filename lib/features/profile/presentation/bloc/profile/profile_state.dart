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

  /// true => البيانات معروضة من الكاش (Offline)
  /// false => البيانات جاءت من الـ API
  final bool isFromCache;

  const ProfileLoaded({
    required this.profile,
    this.isFromCache = false,
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