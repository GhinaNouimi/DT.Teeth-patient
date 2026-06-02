import '../../data/models/forgot_password_reset_password_request_model.dart';
import '../../data/models/forgot_password_response_model.dart';
import '../../data/models/forgot_password_send_code_request_model.dart';
import '../../data/models/forgot_password_verify_code_request_model.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/login_response_model.dart';
import '../../data/models/register_patient_request_model.dart';
import '../../data/models/register_response_model.dart';
import '../../data/models/send_verification_request_model.dart';
import '../../data/models/send_verification_response_model.dart';
import '../../data/models/verify_email_request_model.dart';
import '../../data/models/verify_email_response_model.dart';

abstract class AuthRepository {
  Future<RegisterResponseModel> registerPatient(
      RegisterPatientRequestModel request,
      );

  Future<VerifyEmailResponseModel> verifyEmail(
      VerifyEmailRequestModel request,
      );

  Future<SendVerificationResponseModel> sendVerification(
      SendVerificationRequestModel request,
      );

  Future<LoginResponseModel> loginPatient(
      LoginRequestModel request,
      );

  Future<ForgotPasswordResponseModel> sendForgotPasswordCode(
      ForgotPasswordSendCodeRequestModel request,
      );

  Future<ForgotPasswordResponseModel> verifyForgotPasswordCode(
      ForgotPasswordVerifyCodeRequestModel request,
      );

  Future<ForgotPasswordResponseModel> resetPassword(
      ForgotPasswordResetPasswordRequestModel request,
      );
}