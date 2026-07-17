class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://192.168.34.250:8000/api';

  // Authentication
  static const String patientRegister = '/patient/register';
  static const String patientVerifyEmail = '/patient/verifyEmail';
  static const String patientSendVerification = '/patient/sendVerification';
  static const String patientLogin = '/patient/login';

  // Forgot Password
  static const String forgotPasswordSendCode =
      '/forgotPassword/sendCode';

  static const String forgotPasswordVerifyCode =
      '/forgotPassword/verifyCode';

  static const String forgotPasswordResetPassword =
      '/forgotPassword/resetPassword';

  // Profile
  static const String patientLogout = '/patient/logout';
  static const String patientShowProfile = '/patient/showProfile';
  static const String patientEditProfile = '/patient/editProfile';

// Appointments
  static const String patientShowAppointments =
      '/patient/showAppointments';

  static const String patientShowPreviousAppointments =
      '/patient/showPreviousAppointments';

  static String patientShowAppointmentDetails(
      int appointmentId,
      ) =>
      '/patient/showAppointmentdetails/$appointmentId';

  static String patientCancelAppointment(
      int appointmentId,
      ) =>
      '/patient/cancelAppointment/$appointmentId';


  // Prescriptions
  static const String patientShowAllPrescriptions =
      '/patient/showAllPrescriptions';

  static String patientShowPrescriptionDetails(
      int prescriptionId,
      ) =>
      '/patient/showPrescriptionDetails/$prescriptionId';

  // Doctors
  static const String patientShowAllDentists =
      '/showAllDentists';

  static String patientShowDentistDetails(int dentistId) =>
      '/patient/showDentistDetails/$dentistId';

  static String patientShowDentistRate(int dentistId) =>
      '/patient/showDentistRate/$dentistId';

  static String patientShowDentistsBySpecialization(int specializationId) =>
      '/patient/showDentistsBySpecialization/$specializationId';

  static String patientAddDentistRate(int dentistId) =>
      '/patient/addDentistRate/$dentistId';
  // Treatments
  static const String patientShowAllTreatments =
      '/patient/showAllTreatments';

  static String patientShowTreatmentDetails(int treatmentId) =>
      '/patient/showTreatmentdetails/$treatmentId';

  // Complaints
  static const String patientShowAllComplaints =
      '/patient/showAllComplaints';

  static const String patientAddComplaint =
      '/patient/addComplaint';
}