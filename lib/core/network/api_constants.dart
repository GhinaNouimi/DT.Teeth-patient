class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://5.5.5.131:8000/api';

  static const String patientRegister = '/patient/register';
  static const String patientVerifyEmail = '/patient/verifyEmail';
  static const String patientSendVerification = '/patient/sendVerification';
  static const String patientLogin = '/patient/login';

  static const String forgotPasswordSendCode = '/forgotPassword/sendCode';

  static const String forgotPasswordVerifyCode = '/forgotPassword/verifyCode';

  static const String forgotPasswordResetPassword = '/forgotPassword/resetPassword';
}