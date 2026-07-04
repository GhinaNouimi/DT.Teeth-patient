class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://192.168.34.250:8000/api';

  static const String patientRegister = '/patient/register';
  static const String patientVerifyEmail = '/patient/verifyEmail';
  static const String patientSendVerification = '/patient/sendVerification';
  static const String patientLogin = '/patient/login';

  static const String forgotPasswordSendCode = '/forgotPassword/sendCode';

  static const String forgotPasswordVerifyCode = '/forgotPassword/verifyCode';

  static const String forgotPasswordResetPassword = '/forgotPassword/resetPassword';
  static const String patientLogout = '/patient/logout';
  static const String patientShowProfile = '/patient/showProfile';
  static const String patientEditProfile = '/patient/editProfile';
  // Appointments
  static const String patientShowAppointments =
      '/patient/showAppointments';
  static const String patientShowPreviousAppointments =
      '/patient/showPreviousAppointments';
  static const String patientShowAppointmentDetails =
      '/patient/showAppointmentdetails';
  static const String patientCancelAppointment =
      '/patient/cancelAppointment';
  static const String patientShowAllPrescriptions =
      '/patient/showAllPrescriptions';

  static String patientShowPrescriptionDetails(int prescriptionId) =>
      '/patient/showPrescriptionDetails/$prescriptionId';
}