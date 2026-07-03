import '../../../data/models/send_verification_request_model.dart';
import '../../../data/models/verify_email_request_model.dart';

abstract class VerifyEmailEvent {
  const VerifyEmailEvent();
}

class VerifyEmailSubmitted extends VerifyEmailEvent {
  final VerifyEmailRequestModel request;
  final String languageCode;

  const VerifyEmailSubmitted({
    required this.request,
    required this.languageCode,
  });
}

class ResendVerificationSubmitted extends VerifyEmailEvent {
  final SendVerificationRequestModel request;
  final String languageCode;

  const ResendVerificationSubmitted({
    required this.request,
    required this.languageCode,
  });
}