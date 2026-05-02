import 'package:dt_teeth/features/appointments/presentation/pages/reschedule_appointment_screen.dart';
import 'package:go_router/go_router.dart';

import '../../features/appointments/presentation/pages/appointment_details_screen.dart';
import '../../features/auth/presentation/pages/forget_password/forgot_password_screen.dart';
import '../../features/auth/presentation/pages/forget_password/reset_password_screen.dart';
import '../../features/auth/presentation/pages/forget_password/verify_reset_code_screen.dart';
import '../../features/auth/presentation/pages/login/login_screen.dart';
import '../../features/auth/presentation/pages/on_boarding/splash_screen.dart';
import '../../features/auth/presentation/pages/signup/signup_screen.dart';
import '../../features/auth/presentation/pages/verify_account/verify_screen.dart';
import '../../features/doctors/presentation/models/doctor_ui_model.dart';
import '../../features/doctors/presentation/pages/DoctorProfileScreen.dart';
import '../../features/doctors/presentation/pages/book_doctor_appointment_screen.dart';
import '../../features/doctors/presentation/pages/doctors_screen.dart';
import '../../features/main_shell/pages/patient_main_shell_screen.dart';
import 'app_routes.dart';

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
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.verify,
        name: 'verify',
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return VerifyScreen(email: email);
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
        builder: (context, state) => const AppointmentDetailsScreen(),
      ),
      GoRoute(
        path: AppRoutes.rescheduleAppointment,
        name: 'reschedule-appointment',
        builder: (context, state) => const RescheduleAppointmentScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctors,
        name: 'doctors',
        builder: (context, state) => const DoctorsScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorProfile,
        name: 'doctor-profile',
        builder: (context, state) {
          final doctor = state.extra as DoctorUiModel;
          return DoctorProfileScreen(doctor: doctor);
        },
      ),
      GoRoute(
        path: AppRoutes.bookDoctorAppointment,
        name: 'book-doctor-appointment',
        builder: (context, state) {
          final doctor = state.extra as DoctorUiModel;
          return BookDoctorAppointmentScreen(doctor: doctor);
        },
      ),
    ],
  );
}
