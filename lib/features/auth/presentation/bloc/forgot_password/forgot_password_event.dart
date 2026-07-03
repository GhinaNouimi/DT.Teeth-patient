import '../../../data/models/forgot_password_reset_password_request_model.dart';
import '../../../data/models/forgot_password_send_code_request_model.dart';
import '../../../data/models/forgot_password_verify_code_request_model.dart';

abstract class ForgotPasswordEvent {
  const ForgotPasswordEvent();
}

class SendForgotPasswordCodeSubmitted extends ForgotPasswordEvent {
  final ForgotPasswordSendCodeRequestModel request;
  final String languageCode;

  const SendForgotPasswordCodeSubmitted({
    required this.request,
    required this.languageCode,
  });
}

class VerifyForgotPasswordCodeSubmitted extends ForgotPasswordEvent {
  final ForgotPasswordVerifyCodeRequestModel request;
  final String languageCode;

  const VerifyForgotPasswordCodeSubmitted({
    required this.request,
    required this.languageCode,
  });
}

class ResetPasswordSubmitted extends ForgotPasswordEvent {
  final ForgotPasswordResetPasswordRequestModel request;
  final String languageCode;

  const ResetPasswordSubmitted({
    required this.request,
    required this.languageCode,
  });
}