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

  const VerifyEmailSuccess({
    required this.response,
  });
}

class VerifyEmailFailure extends VerifyEmailState {
  final String message;

  const VerifyEmailFailure({
    required this.message,
  });
}