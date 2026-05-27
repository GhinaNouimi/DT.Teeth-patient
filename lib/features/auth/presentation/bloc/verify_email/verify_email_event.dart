import '../../../data/models/verify_email_request_model.dart';

abstract class VerifyEmailEvent {
  const VerifyEmailEvent();
}

class VerifyEmailSubmitted extends VerifyEmailEvent {
  final VerifyEmailRequestModel request;

  const VerifyEmailSubmitted({
    required this.request,
  });
}