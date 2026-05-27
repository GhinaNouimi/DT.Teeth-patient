import '../../../data/models/login_request_model.dart';

abstract class LoginEvent {
  const LoginEvent();
}

class LoginPatientSubmitted extends LoginEvent {
  final LoginRequestModel request;

  const LoginPatientSubmitted({
    required this.request,
  });
}