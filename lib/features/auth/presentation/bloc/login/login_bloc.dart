import 'package:bloc/bloc.dart';

import '../../../../../core/network/api_error_handler.dart';
import '../../../../../core/network/network_info.dart';
import '../../../domain/usecases/login_patient_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginPatientUseCase loginPatientUseCase;
  final NetworkInfo networkInfo;

  LoginBloc({
    required this.loginPatientUseCase,
    required this.networkInfo,
  }) : super(const LoginInitial()) {
    on<LoginPatientSubmitted>(_onLoginPatientSubmitted);
  }

  String _noInternetMessage(String languageCode) {
    return languageCode.toLowerCase().startsWith('ar')
        ? 'لا يوجد اتصال بالإنترنت، يرجى المحاولة لاحقًا'
        : 'No internet connection. Please try again later.';
  }

  Future<void> _onLoginPatientSubmitted(
      LoginPatientSubmitted event,
      Emitter<LoginState> emit,
      ) async {
    emit(const LoginLoading());

    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      emit(
        LoginFailure(
          message: _noInternetMessage(event.languageCode),
        ),
      );
      return;
    }

    try {
      final response = await loginPatientUseCase(event.request);
      emit(LoginSuccess(response: response));
    } catch (error) {
      emit(
        LoginFailure(
          message: ApiErrorHandler.handle(
            error,
            languageCode: event.languageCode,
          ),
        ),
      );
    }
  }
}