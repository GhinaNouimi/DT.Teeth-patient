import '../../../data/models/register_response_model.dart';

abstract class RegisterState {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  final RegisterResponseModel response;

  const RegisterSuccess({required this.response});
}

class RegisterFailure extends RegisterState {
  final String message;

  const RegisterFailure({required this.message});
}
