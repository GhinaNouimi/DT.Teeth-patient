import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dt_teeth/core/routing/app_routes.dart';
import 'package:dt_teeth/features/appointments/presentaion/pages/emergency_appointment_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/appointments/presentaion/models/appointment_ui_model.dart';
import '../../features/appointments/presentaion/pages/appointment_details_screen.dart';
import '../../features/appointments/presentaion/pages/appointments_management_screen.dart';
import '../../features/appointments/presentaion/pages/new_appointment_screen.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/login_patient_usecase.dart';
import '../../features/auth/domain/usecases/register_patient_usecase.dart';
import '../../features/auth/domain/usecases/verify_email_usecase.dart';
import '../../features/auth/presentation/bloc/login/login_bloc.dart';
import '../../features/auth/presentation/bloc/register/register_bloc.dart';
import '../../features/auth/presentation/bloc/verify_email/verify_email_bloc.dart';
import '../../features/auth/presentation/pages/forget_password/forgot_password_screen.dart';
import '../../features/auth/presentation/pages/forget_password/reset_password_screen.dart';
import '../../features/auth/presentation/pages/forget_password/verify_reset_code_screen.dart';
import '../../features/auth/presentation/pages/login/login_screen.dart';
import '../../features/auth/presentation/pages/on_boarding/splash_screen.dart';
import '../../features/auth/presentation/pages/signup/patient_health_questions_screen.dart';
import '../../features/auth/presentation/pages/signup/signup_screen.dart';
import '../../features/auth/presentation/pages/verify_account/verify_screen.dart';
import '../../features/doctors/presentation/models/doctor_ui_model.dart';
import '../../features/doctors/presentation/pages/booking_screen.dart';
import '../../features/doctors/presentation/pages/doctor_profile_screen.dart';
import '../../features/appointments/presentaion/pages/reschedule_appointment_screen.dart';
import '../../features/main_shell/pages/patient_main_shell_screen.dart';
import '../../features/medical_record/presentation/pages/attachments_screen.dart';
import '../../features/medical_record/presentation/pages/payment_plan_details_screen.dart';
import '../../features/medical_record/presentation/pages/payments_screen.dart';
import '../../features/medical_record/presentation/pages/prescription_details_screen.dart';
import '../../features/medical_record/presentation/pages/prescriptions_screen.dart';
import '../../features/medical_record/presentation/pages/treatment_details_screen.dart';
import '../../features/medical_record/presentation/pages/treatments_screen.dart';
import '../network/network_info.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => LoginBloc(
              loginPatientUseCase: LoginPatientUseCase(
                repository: AuthRepositoryImpl(
                  remoteDataSource: AuthRemoteDataSourceImpl(),
                ),
              ),
              networkInfo: NetworkInfo(
                connectivity: Connectivity(),
              ),
            ),
            child: const LoginScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),

      GoRoute(
        path: AppRoutes.patientHealthQuestions,
        name: 'patient-health-questions',
        builder: (context, state) {
          final basicRegisterData = state.extra as Map<String, dynamic>? ?? {};

          return BlocProvider(
            create: (_) => RegisterBloc(
              registerPatientUseCase: RegisterPatientUseCase(
                repository: AuthRepositoryImpl(
                  remoteDataSource: AuthRemoteDataSourceImpl(),
                ),
              ),
              networkInfo: NetworkInfo(
                connectivity: Connectivity(),
              ),
            ),
            child: PatientHealthQuestionsScreen(
              basicRegisterData: basicRegisterData,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.verify,
        name: 'verify',
        builder: (context, state) {
          final email = state.extra as String? ?? '';

          return BlocProvider(
            create: (_) => VerifyEmailBloc(
              verifyEmailUseCase: VerifyEmailUseCase(
                repository: AuthRepositoryImpl(
                  remoteDataSource: AuthRemoteDataSourceImpl(),
                ),
              ),
              networkInfo: NetworkInfo(
                connectivity: Connectivity(),
              ),
            ),
            child: VerifyScreen(email: email),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyResetCode,
        name: 'verify-reset-code',
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return VerifyResetCodeScreen(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        name: 'reset-password',
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return ResetPasswordScreen(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const PatientMainShellScreen(),
      ),
      GoRoute(
        path: AppRoutes.appointmentDetails,
        name: 'appointment-details',
        builder: (context, state) {
          final appointment = state.extra as AppointmentUiModel;
          return AppointmentDetailsScreen(appointment: appointment);
        },
      ),

      GoRoute(
        path: AppRoutes.appointmentsManagement,
        name: 'appointments-management',
        builder: (context, state) => const AppointmentsManagementScreen(),
      ),

      GoRoute(
        path: AppRoutes.newAppointment,
        name: 'new-appointment',
        builder: (context, state) => const NewAppointmentScreen(),
      ),

      GoRoute(
        path: AppRoutes.emergencyAppointment,
        name: 'emergency_appointment',
        builder: (context, state) => const EmergencyAppointmentScreen(),
      ),

      GoRoute(
        path: AppRoutes.rescheduleAppointment,
        name: 'reschedule-appointment',
        builder: (context, state) {
          final appointment = state.extra as AppointmentUiModel;
          return RescheduleAppointmentScreen(appointment: appointment);
        },
      ),
      GoRoute(
        path: AppRoutes.doctorDetails,
        name: 'doctor-details',
        builder: (context, state) {
          final doctor = state.extra as DoctorUiModel;
          return DoctorProfileScreen(doctor: doctor);
        },
      ),
      GoRoute(
        path: AppRoutes.booking,
        name: 'booking',
        builder: (context, state) {
          final doctor = state.extra as DoctorUiModel;
          return BookingScreen(doctor: doctor);
        },
      ),

      GoRoute(
        path: AppRoutes.medicalRecordTreatments,
        name: 'medical-record-treatments',
        builder: (context, state) => const TreatmentsScreen(),
      ),
      GoRoute(
        path: AppRoutes.medicalRecordTreatmentDetails,
        name: 'medical-record-treatment-details',
        builder: (context, state) {
          final treatmentId = state.extra as String;
          return TreatmentDetailsScreen(treatmentId: treatmentId);
        },
      ),
      GoRoute(
        path: AppRoutes.medicalRecordAttachments,
        name: 'medical-record-attachments',
        builder: (context, state) {
          final treatmentId = state.extra as String;
          return AttachmentsScreen(treatmentId: treatmentId);
        },
      ),
      GoRoute(
        path: AppRoutes.medicalRecordPrescriptions,
        name: 'medical-record-prescriptions',
        builder: (context, state) => const PrescriptionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.medicalRecordPrescriptionDetails,
        name: 'medical-record-prescription-details',
        builder: (context, state) {
          final prescriptionId = state.extra as String;
          return PrescriptionDetailsScreen(prescriptionId: prescriptionId);
        },
      ),
      GoRoute(
        path: AppRoutes.medicalRecordPayments,
        name: 'medical-record-payments',
        builder: (context, state) => const PaymentsScreen(),
      ),
      GoRoute(
        path: AppRoutes.medicalRecordPaymentPlanDetails,
        name: 'medical-record-payment-plan-details',
        builder: (context, state) => const PaymentPlanDetailsScreen(),
      ),
    ],
  );
}
