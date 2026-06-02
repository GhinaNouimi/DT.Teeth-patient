import '../../data/datasources/auth_remote_data_source.dart';

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

import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<RegisterResponseModel> registerPatient(
      RegisterPatientRequestModel request,
      ) {
    return remoteDataSource.registerPatient(request);
  }

  @override
  Future<VerifyEmailResponseModel> verifyEmail(
      VerifyEmailRequestModel request,
      ) {
    return remoteDataSource.verifyEmail(request);
  }

  @override
  Future<SendVerificationResponseModel> sendVerification(
      SendVerificationRequestModel request,
      ) {
    return remoteDataSource.sendVerification(request);
  }

  @override
  Future<LoginResponseModel> loginPatient(
      LoginRequestModel request,
      ) {
    return remoteDataSource.loginPatient(request);
  }

  @override
  Future<ForgotPasswordResponseModel> sendForgotPasswordCode(
      ForgotPasswordSendCodeRequestModel request,
      ) {
    return remoteDataSource.sendForgotPasswordCode(request);
  }

  @override
  Future<ForgotPasswordResponseModel> verifyForgotPasswordCode(
      ForgotPasswordVerifyCodeRequestModel request,
      ) {
    return remoteDataSource.verifyForgotPasswordCode(request);
  }

  @override
  Future<ForgotPasswordResponseModel> resetPassword(
      ForgotPasswordResetPasswordRequestModel request,
      ) {
    return remoteDataSource.resetPassword(request);
  }
}