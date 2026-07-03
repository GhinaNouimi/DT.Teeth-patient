import '../../../data/models/login_request_model.dart';

abstract class LoginEvent {
  const LoginEvent();
}

class LoginPatientSubmitted extends LoginEvent {
  final LoginRequestModel request;
  final String languageCode;

  const LoginPatientSubmitted({
    required this.request,
    required this.languageCode,
  });
}