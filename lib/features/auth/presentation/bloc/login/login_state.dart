import '../../../data/models/login_response_model.dart';

abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final LoginResponseModel response;

  const LoginSuccess({
    required this.response,
  });
}

class LoginFailure extends LoginState {
  final String message;

  const LoginFailure({
    required this.message,
  });
}