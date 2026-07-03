import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_error_handler.dart';
import '../../../../../core/network/network_info.dart';
import '../../../domain/usecases/get_profile_use_case.dart';
import '../../../domain/usecases/update_profile_use_case.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final NetworkInfo networkInfo;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.networkInfo,
  }) : super(const ProfileInitial()) {
    on<LoadProfileRequested>(_onLoadProfileRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }

  String _noInternetMessage(String languageCode) {
    return languageCode.toLowerCase().startsWith('ar')
        ? 'لا يوجد اتصال بالإنترنت.'
        : 'No internet connection.';
  }

  Future<void> _onLoadProfileRequested(
      LoadProfileRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoading());

    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      emit(
        ProfileFailure(
          message: _noInternetMessage(event.languageCode),
        ),
      );
      return;
    }

    try {
      final profile = await getProfileUseCase();
      emit(ProfileLoaded(profile: profile));
    } catch (error) {
      emit(
        ProfileFailure(
          message: ApiErrorHandler.handle(
            error,
            languageCode: event.languageCode,
          ),
        ),
      );
    }
  }

  Future<void> _onUpdateProfileRequested(
      UpdateProfileRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileUpdating(profile: event.profile));

    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      emit(
        ProfileFailure(
          message: _noInternetMessage(event.languageCode),
        ),
      );
      return;
    }

    try {
      final profile = await updateProfileUseCase(
        event.profile,
        profilePicture: event.profilePicture,
      );

      emit(ProfileUpdateSuccess(profile: profile));
      emit(ProfileLoaded(profile: profile));
    } catch (error) {
      emit(
        ProfileFailure(
          message: ApiErrorHandler.handle(
            error,
            languageCode: event.languageCode,
          ),
        ),
      );
    }
  }
}