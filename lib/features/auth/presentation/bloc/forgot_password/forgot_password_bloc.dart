import 'package:bloc/bloc.dart';

import '../../../../../core/network/api_error_handler.dart';
import '../../../../../core/network/network_info.dart';
import '../../../domain/usecases/reset_password_usecase.dart';
import '../../../domain/usecases/send_forgot_password_code_usecase.dart';
import '../../../domain/usecases/verify_forgot_password_code_usecase.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final SendForgotPasswordCodeUseCase sendForgotPasswordCodeUseCase;
  final VerifyForgotPasswordCodeUseCase verifyForgotPasswordCodeUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final NetworkInfo networkInfo;

  ForgotPasswordBloc({
    required this.sendForgotPasswordCodeUseCase,
    required this.verifyForgotPasswordCodeUseCase,
    required this.resetPasswordUseCase,
    required this.networkInfo,
  }) : super(const ForgotPasswordInitial()) {
    on<SendForgotPasswordCodeSubmitted>(_onSendForgotPasswordCodeSubmitted);
    on<VerifyForgotPasswordCodeSubmitted>(_onVerifyForgotPasswordCodeSubmitted);
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
  }

  Future<void> _onSendForgotPasswordCodeSubmitted(
      SendForgotPasswordCodeSubmitted event,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(const ForgotPasswordLoading());

    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      emit(
        const ForgotPasswordFailure(
          message: 'لا يوجد اتصال بالإنترنت، يرجى المحاولة لاحقًا',
        ),
      );
      return;
    }

    try {
      final response = await sendForgotPasswordCodeUseCase(event.request);
      emit(ForgotPasswordSendCodeSuccess(response: response));
    } catch (error) {
      emit(ForgotPasswordFailure(message: ApiErrorHandler.handle(error)));
    }
  }

  Future<void> _onVerifyForgotPasswordCodeSubmitted(
      VerifyForgotPasswordCodeSubmitted event,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(const ForgotPasswordLoading());

    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      emit(
        const ForgotPasswordFailure(
          message: 'لا يوجد اتصال بالإنترنت، يرجى المحاولة لاحقًا',
        ),
      );
      return;
    }

    try {
      final response = await verifyForgotPasswordCodeUseCase(event.request);
      emit(ForgotPasswordVerifyCodeSuccess(response: response));
    } catch (error) {
      emit(ForgotPasswordFailure(message: ApiErrorHandler.handle(error)));
    }
  }

  Future<void> _onResetPasswordSubmitted(
      ResetPasswordSubmitted event,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(const ForgotPasswordLoading());

    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      emit(
        const ForgotPasswordFailure(
          message: 'لا يوجد اتصال بالإنترنت، يرجى المحاولة لاحقًا',
        ),
      );
      return;
    }

    try {
      final response = await resetPasswordUseCase(event.request);
      emit(ForgotPasswordResetSuccess(response: response));
    } catch (error) {
      emit(ForgotPasswordFailure(message: ApiErrorHandler.handle(error)));
    }
  }
}