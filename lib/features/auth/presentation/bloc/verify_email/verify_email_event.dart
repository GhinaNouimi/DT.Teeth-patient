import '../../../data/models/send_verification_request_model.dart';
import '../../../data/models/verify_email_request_model.dart';

abstract class VerifyEmailEvent {
  const VerifyEmailEvent();
}

class VerifyEmailSubmitted extends VerifyEmailEvent {
  final VerifyEmailRequestModel request;

  const VerifyEmailSubmitted({required this.request});
}

class ResendVerificationSubmitted extends VerifyEmailEvent {
  final SendVerificationRequestModel request;

  const ResendVerificationSubmitted({required this.request});
}