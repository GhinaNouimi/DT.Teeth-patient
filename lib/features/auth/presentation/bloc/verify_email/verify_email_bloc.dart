import 'package:bloc/bloc.dart';

import '../../../../../core/network/api_error_handler.dart';
import '../../../../../core/network/network_info.dart';
import '../../../domain/usecases/send_verification_usecase.dart';
import '../../../domain/usecases/verify_email_usecase.dart';
import 'verify_email_event.dart';
import 'verify_email_state.dart';

class VerifyEmailBloc extends Bloc<VerifyEmailEvent, VerifyEmailState> {
  final VerifyEmailUseCase verifyEmailUseCase;
  final SendVerificationUseCase sendVerificationUseCase;
  final NetworkInfo networkInfo;

  VerifyEmailBloc({
    required this.verifyEmailUseCase,
    required this.sendVerificationUseCase,
    required this.networkInfo,
  }) : super(const VerifyEmailInitial()) {
    on<VerifyEmailSubmitted>(_onVerifyEmailSubmitted);
    on<ResendVerificationSubmitted>(_onResendVerificationSubmitted);
  }

  Future<void> _onVerifyEmailSubmitted(
      VerifyEmailSubmitted event,
      Emitter<VerifyEmailState> emit,
      ) async {
    emit(const VerifyEmailLoading());

    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      emit(
        const VerifyEmailFailure(
          message: 'لا يوجد اتصال بالإنترنت، يرجى المحاولة لاحقًا',
        ),
      );
      return;
    }

    try {
      final response = await verifyEmailUseCase(event.request);
      emit(VerifyEmailSuccess(response: response));
    } catch (error) {
      emit(VerifyEmailFailure(message: ApiErrorHandler.handle(error)));
    }
  }

  Future<void> _onResendVerificationSubmitted(
      ResendVerificationSubmitted event,
      Emitter<VerifyEmailState> emit,
      ) async {
    emit(const ResendVerificationLoading());

    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      emit(
        const ResendVerificationFailure(
          message: 'لا يوجد اتصال بالإنترنت، يرجى المحاولة لاحقًا',
        ),
      );
      return;
    }

    try {
      final response = await sendVerificationUseCase(event.request);
      emit(ResendVerificationSuccess(response: response));
    } catch (error) {
      emit(ResendVerificationFailure(message: ApiErrorHandler.handle(error)));
    }
  }
}