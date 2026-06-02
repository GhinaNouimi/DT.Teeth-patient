import '../../data/models/forgot_password_reset_password_request_model.dart';
import '../../data/models/forgot_password_response_model.dart';
import '../../data/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  const ResetPasswordUseCase({
    required this.repository,
  });

  Future<ForgotPasswordResponseModel> call(
      ForgotPasswordResetPasswordRequestModel request,
      ) {
    return repository.resetPassword(request);
  }
}