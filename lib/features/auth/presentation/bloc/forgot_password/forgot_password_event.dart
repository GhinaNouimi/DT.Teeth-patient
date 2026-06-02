import '../../../data/models/forgot_password_reset_password_request_model.dart';
import '../../../data/models/forgot_password_send_code_request_model.dart';
import '../../../data/models/forgot_password_verify_code_request_model.dart';

abstract class ForgotPasswordEvent {
  const ForgotPasswordEvent();
}

class SendForgotPasswordCodeSubmitted extends ForgotPasswordEvent {
  final ForgotPasswordSendCodeRequestModel request;

  const SendForgotPasswordCodeSubmitted({
    required this.request,
  });
}

class VerifyForgotPasswordCodeSubmitted extends ForgotPasswordEvent {
  final ForgotPasswordVerifyCodeRequestModel request;

  const VerifyForgotPasswordCodeSubmitted({
    required this.request,
  });
}

class ResetPasswordSubmitted extends ForgotPasswordEvent {
  final ForgotPasswordResetPasswordRequestModel request;

  const ResetPasswordSubmitted({
    required this.request,
  });
}