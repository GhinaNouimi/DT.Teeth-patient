import '../../data/models/forgot_password_response_model.dart';
import '../../data/models/forgot_password_send_code_request_model.dart';
import '../../data/repositories/auth_repository.dart';

class SendForgotPasswordCodeUseCase {
  final AuthRepository repository;

  const SendForgotPasswordCodeUseCase({
    required this.repository,
  });

  Future<ForgotPasswordResponseModel> call(
      ForgotPasswordSendCodeRequestModel request,
      ) {
    return repository.sendForgotPasswordCode(request);
  }
}