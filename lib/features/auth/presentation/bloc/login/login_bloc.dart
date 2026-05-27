import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

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

  Future<void> _onLoginPatientSubmitted(
      LoginPatientSubmitted event,
      Emitter<LoginState> emit,
      ) async {
    emit(const LoginLoading());

    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      emit(
        const LoginFailure(
          message: 'لا يوجد اتصال بالإنترنت، يرجى المحاولة لاحقًا',
        ),
      );
      return;
    }

    try {
      final response = await loginPatientUseCase(event.request);

      emit(LoginSuccess(response: response));
    } on DioException catch (error) {
      emit(
        LoginFailure(
          message: _extractDioErrorMessage(error),
        ),
      );
    } catch (_) {
      emit(
        const LoginFailure(
          message: 'حدث خطأ غير متوقع، يرجى المحاولة لاحقًا',
        ),
      );
    }
  }

  String _extractDioErrorMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];

      if (message != null) {
        return message.toString();
      }

      final errors = data['errors'];

      if (errors is Map<String, dynamic> && errors.isNotEmpty) {
        final firstError = errors.values.first;

        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
      }
    }

    return 'فشل تسجيل الدخول';
  }
}