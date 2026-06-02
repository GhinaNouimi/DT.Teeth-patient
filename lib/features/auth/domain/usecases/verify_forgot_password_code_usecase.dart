import '../../data/models/forgot_password_response_model.dart';
import '../../data/models/forgot_password_verify_code_request_model.dart';
import '../../data/repositories/auth_repository.dart';

class VerifyForgotPasswordCodeUseCase {
  final AuthRepository repository;

  const VerifyForgotPasswordCodeUseCase({
    required this.repository,
  });

  Future<ForgotPasswordResponseModel> call(
      ForgotPasswordVerifyCodeRequestModel request,
      ) {
    return repository.verifyForgotPasswordCode(request);
  }
}