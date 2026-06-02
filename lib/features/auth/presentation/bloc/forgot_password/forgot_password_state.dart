import '../../../data/models/forgot_password_response_model.dart';

abstract class ForgotPasswordState {
  const ForgotPasswordState();
}

class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

class ForgotPasswordLoading extends ForgotPasswordState {
  const ForgotPasswordLoading();
}

class ForgotPasswordSendCodeSuccess extends ForgotPasswordState {
  final ForgotPasswordResponseModel response;

  const ForgotPasswordSendCodeSuccess({
    required this.response,
  });
}

class ForgotPasswordVerifyCodeSuccess extends ForgotPasswordState {
  final ForgotPasswordResponseModel response;

  const ForgotPasswordVerifyCodeSuccess({
    required this.response,
  });
}

class ForgotPasswordResetSuccess extends ForgotPasswordState {
  final ForgotPasswordResponseModel response;

  const ForgotPasswordResetSuccess({
    required this.response,
  });
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String message;

  const ForgotPasswordFailure({
    required this.message,
  });
}