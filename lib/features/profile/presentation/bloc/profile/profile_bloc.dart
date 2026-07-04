import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/cache/cache_exception.dart';
import '../../../../../core/network/api_error_handler.dart';
import '../../../../../core/network/network_error_messages.dart';
import '../../../../../core/network/offline_exception.dart';
import '../../../domain/usecases/get_profile_use_case.dart';
import '../../../domain/usecases/update_profile_use_case.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(const ProfileInitial()) {
    on<LoadProfileRequested>(_onLoadProfileRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }

  Future<void> _onLoadProfileRequested(
      LoadProfileRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoading());

    try {
      final result = await getProfileUseCase();

      emit(
        ProfileLoaded(
          profile: result.data,
          isFromCache: result.isFromCache,
        ),
      );
    } on CacheException {
      emit(
        ProfileFailure(
          message: NetworkErrorMessages.noCachedData(event.languageCode),
        ),
      );
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

    try {
      final profile = await updateProfileUseCase(
        event.profile,
        profilePicture: event.profilePicture,
      );

      emit(ProfileUpdateSuccess(profile: profile));
      emit(
        ProfileLoaded(
          profile: profile,
          isFromCache: false,
        ),
      );
    } on OfflineException {
      emit(
        ProfileFailure(
          message: NetworkErrorMessages.offlineActionNotAllowed(
            event.languageCode,
          ),
        ),
      );
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