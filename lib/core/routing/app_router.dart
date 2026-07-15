import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dt_teeth/core/routing/app_routes.dart';
import 'package:dt_teeth/features/appointments/presentaion/pages/emergency_appointment_screen.dart';
import 'package:dt_teeth/features/auth/domain/usecases/logout_patient_usecase.dart';
import 'package:dt_teeth/features/auth/presentation/bloc/logout/logout_bloc.dart';
import 'package:flutter/cupertino.dart';
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
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/send_forgot_password_code_usecase.dart';
import '../../features/auth/domain/usecases/send_verification_usecase.dart';
import '../../features/auth/domain/usecases/verify_email_usecase.dart';
import '../../features/auth/domain/usecases/verify_forgot_password_code_usecase.dart';
import '../../features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart';
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
import '../../features/complaints/domain/entities/complaint_entity.dart';
import '../../features/complaints/presentation/pages/complaint_details_screen.dart';
import '../../features/complaints/presentation/pages/complaints_list_screen.dart';
import '../../features/complaints/presentation/pages/create_complaint_screen.dart';
import '../../features/doctors/presentation/pages/doctor_profile_screen.dart';
import '../../features/appointments/presentaion/pages/reschedule_appointment_screen.dart';
import '../../features/main_shell/pages/patient_main_shell_screen.dart';
import '../../features/medical_record/presentation/pages/attachments_screen.dart';
import '../../features/medical_record/presentation/pages/payment_plan_details_screen.dart';
import '../../features/medical_record/presentation/pages/payments_screen.dart';

import '../../features/medical_record/presentation/pages/prescription/prescription_details_screen.dart';
import '../../features/medical_record/presentation/pages/prescription/prescriptions_screen.dart';
import '../../features/medical_record/presentation/pages/treatment_details_screen.dart';
import '../../features/medical_record/presentation/pages/treatments_screen.dart';
import '../../features/profile/domain/entities/profile_entity.dart';
import '../../features/profile/presentation/bloc/profile/profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile/profile_event.dart';
import '../../features/profile/presentation/pages/edit_profile_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/profile/profile_di.dart';
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
          final repository = AuthRepositoryImpl(
            remoteDataSource: AuthRemoteDataSourceImpl(),
          );

          return BlocProvider(
            create: (_) => LoginBloc(
              loginPatientUseCase: LoginPatientUseCase(
                repository: repository,
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

          final repository = AuthRepositoryImpl(
            remoteDataSource: AuthRemoteDataSourceImpl(),
          );

          return BlocProvider(
            create: (_) => RegisterBloc(
              registerPatientUseCase: RegisterPatientUseCase(
                repository: repository,
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
            create: (_) {
              final repository = AuthRepositoryImpl(
                remoteDataSource: AuthRemoteDataSourceImpl(),
              );

              return VerifyEmailBloc(
                verifyEmailUseCase: VerifyEmailUseCase(
                  repository: repository,
                ),
                sendVerificationUseCase: SendVerificationUseCase(
                  repository: repository,
                ),
                networkInfo: NetworkInfo(
                  connectivity: Connectivity(),
                ),
              );
            },
            child: VerifyScreen(email: email),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgot-password',
        builder: (context, state) {
          final repository = AuthRepositoryImpl(
            remoteDataSource: AuthRemoteDataSourceImpl(),
          );

          return BlocProvider(
            create: (_) => ForgotPasswordBloc(
              sendForgotPasswordCodeUseCase: SendForgotPasswordCodeUseCase(
                repository: repository,
              ),
              verifyForgotPasswordCodeUseCase: VerifyForgotPasswordCodeUseCase(
                repository: repository,
              ),
              resetPasswordUseCase: ResetPasswordUseCase(
                repository: repository,
              ),
              networkInfo: NetworkInfo(connectivity: Connectivity()),
            ),
            child: const ForgotPasswordScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.verifyResetCode,
        name: 'verify-reset-code',
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          final repository = AuthRepositoryImpl(
            remoteDataSource: AuthRemoteDataSourceImpl(),
          );

          return BlocProvider(
            create: (_) => ForgotPasswordBloc(
              sendForgotPasswordCodeUseCase: SendForgotPasswordCodeUseCase(
                repository: repository,
              ),
              verifyForgotPasswordCodeUseCase: VerifyForgotPasswordCodeUseCase(
                repository: repository,
              ),
              resetPasswordUseCase: ResetPasswordUseCase(
                repository: repository,
              ),
              networkInfo: NetworkInfo(connectivity: Connectivity()),
            ),
            child: VerifyResetCodeScreen(email: email),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        name: 'reset-password',
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          final repository = AuthRepositoryImpl(
            remoteDataSource: AuthRemoteDataSourceImpl(),
          );

          return BlocProvider(
            create: (_) => ForgotPasswordBloc(
              sendForgotPasswordCodeUseCase: SendForgotPasswordCodeUseCase(
                repository: repository,
              ),
              verifyForgotPasswordCodeUseCase: VerifyForgotPasswordCodeUseCase(
                repository: repository,
              ),
              resetPasswordUseCase: ResetPasswordUseCase(
                repository: repository,
              ),
              networkInfo: NetworkInfo(connectivity: Connectivity()),
            ),
            child: ResetPasswordScreen(email: email),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) {
          final authRepository = AuthRepositoryImpl(
            remoteDataSource: AuthRemoteDataSourceImpl(),
          );

          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => LogoutBloc(
                  logoutPatientUseCase: LogoutPatientUseCase(
                    repository: authRepository,
                  ),
                  networkInfo: NetworkInfo(
                    connectivity: Connectivity(),
                  ),
                ),
              ),
              BlocProvider(
                create: (_) => ProfileBloc(
                  getProfileUseCase: ProfileDi.getProfileUseCase,
                  updateProfileUseCase: ProfileDi.updateProfileUseCase,
                )..add(
                  LoadProfileRequested(
                    languageCode: Localizations.localeOf(context).languageCode,
                  ),
                ),
              ),            ],
            child: const PatientMainShellScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) {
          final repository = AuthRepositoryImpl(
            remoteDataSource: AuthRemoteDataSourceImpl(),
          );

          return BlocProvider(
            create: (_) => LogoutBloc(
              logoutPatientUseCase: LogoutPatientUseCase(
                repository: repository,
              ),
              networkInfo: NetworkInfo(
                connectivity: Connectivity(),
              ),
            ),
            child: const ProfileScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'edit-profile',
        builder: (context, state) {
          final profile = state.extra as ProfileEntity;

          return BlocProvider(
            create: (_) => ProfileBloc(
              getProfileUseCase: ProfileDi.getProfileUseCase,
              updateProfileUseCase: ProfileDi.updateProfileUseCase,
            ),
            child: EditProfileScreen(profile: profile),
          );
        },
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

      // GoRoute(
      //   path: AppRoutes.newAppointment,
      //   name: 'new-appointment',
      //   builder: (context, state) => const NewAppointmentScreen(),
      // ),

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
          final dentistId = state.extra as int;
          return DoctorProfileScreen(dentistId: dentistId);
        },
      ),

      // GoRoute(
      //   path: AppRoutes.booking,
      //   name: 'booking',
      //   builder: (context, state) {
      //     final doctor = state.extra as DoctorUiModel;
      //     return BookingScreen(doctor: doctor);
      //   },
      // ),

      GoRoute(
        path: AppRoutes.medicalRecordTreatments,
        name: 'medical-record-treatments',
        builder: (context, state) => const TreatmentsScreen(),
      ),
      GoRoute(
        path: AppRoutes.medicalRecordTreatmentDetails,
        name: 'medical-record-treatment-details',
        builder: (context, state) {
          final treatmentId = state.extra as int;

          return TreatmentDetailsScreen(
            treatmentId: treatmentId,
          );
        },
      ),
      // GoRoute(
      //   path: AppRoutes.medicalRecordAttachments,
      //   name: 'medical-record-attachments',
      //   builder: (context, state) {
      //     final treatmentId = state.extra as String;
      //     return AttachmentsScreen(treatmentId: treatmentId);
      //   },
      // ),
      GoRoute(
        path: AppRoutes.medicalRecordPrescriptions,
        name: 'medical-record-prescriptions',
        builder: (context, state) => const PrescriptionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.medicalRecordPrescriptionDetails,
        name: 'medical-record-prescription-details',
        builder: (context, state) {
          final prescriptionId = state.extra.toString();
          return PrescriptionDetailsScreen(prescriptionId: prescriptionId);
        },
      ),
      // GoRoute(
      //   path: AppRoutes.medicalRecordPayments,
      //   name: 'medical-record-payments',
      //   builder: (context, state) => const PaymentsScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.medicalRecordPaymentPlanDetails,
      //   name: 'medical-record-payment-plan-details',
      //   builder: (context, state) => const PaymentPlanDetailsScreen(),
      // ),

      GoRoute(
        path: AppRoutes.complaints,
        name: 'complaints',
        builder: (context, state) => const ComplaintsListScreen(),
      ),
      GoRoute(
        path: AppRoutes.createComplaint,
        name: 'create-complaint',
        builder: (context, state) => const CreateComplaintScreen(),
      ),
      GoRoute(
        path: AppRoutes.complaintDetails,
        name: 'complaint-details',
        builder: (context, state) {
          final complaint = state.extra as ComplaintEntity;

          return ComplaintDetailsScreen(
            complaint: complaint,
          );
        },
      ),
    ],
  );
}
