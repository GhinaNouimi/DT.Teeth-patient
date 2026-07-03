import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_error_handler.dart';
import '../../../../../core/network/network_info.dart';
import '../../../domain/usecases/logout_patient_usecase.dart';
import 'logout_event.dart';
import 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutPatientUseCase logoutPatientUseCase;
  final NetworkInfo networkInfo;

  LogoutBloc({
    required this.logoutPatientUseCase,
    required this.networkInfo,
  }) : super(const LogoutInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
  }

  String _noInternetMessage(String languageCode) {
    return languageCode.toLowerCase().startsWith('ar')
        ? 'لا يوجد اتصال بالإنترنت.'
        : 'No internet connection.';
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event,
      Emitter<LogoutState> emit,
      ) async {
    emit(const LogoutLoading());

    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      emit(
        LogoutFailure(
          message: _noInternetMessage(event.languageCode),
        ),
      );
      return;
    }

    try {
      await logoutPatientUseCase();
      emit(const LogoutSuccess());
    } catch (error) {
      emit(
        LogoutFailure(
          message: ApiErrorHandler.handle(
            error,
            languageCode: event.languageCode,
          ),
        ),
      );
    }
  }
}