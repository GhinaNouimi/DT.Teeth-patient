import '../../../data/models/send_verification_response_model.dart';
import '../../../data/models/verify_email_response_model.dart';

abstract class VerifyEmailState {
  const VerifyEmailState();
}

class VerifyEmailInitial extends VerifyEmailState {
  const VerifyEmailInitial();
}

class VerifyEmailLoading extends VerifyEmailState {
  const VerifyEmailLoading();
}

class VerifyEmailSuccess extends VerifyEmailState {
  final VerifyEmailResponseModel response;

  const VerifyEmailSuccess({required this.response});
}

class VerifyEmailFailure extends VerifyEmailState {
  final String message;

  const VerifyEmailFailure({required this.message});
}

class ResendVerificationLoading extends VerifyEmailState {
  const ResendVerificationLoading();
}

class ResendVerificationSuccess extends VerifyEmailState {
  final SendVerificationResponseModel response;

  const ResendVerificationSuccess({required this.response});
}

class ResendVerificationFailure extends VerifyEmailState {
  final String message;

  const ResendVerificationFailure({required this.message});
}