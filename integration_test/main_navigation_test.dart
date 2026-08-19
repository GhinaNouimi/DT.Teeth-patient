import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dt_teeth/core/app/app.dart';
import 'package:dt_teeth/core/connectivity/connectivity_bloc.dart';
import 'package:dt_teeth/core/connectivity/connectivity_event.dart';
import 'package:dt_teeth/core/localization/app_localizations.dart';
import 'package:dt_teeth/core/localization/locale_bloc/locale_bloc.dart';
import 'package:dt_teeth/core/network/network_info.dart';
import 'package:dt_teeth/core/routing/app_router.dart';
import 'package:dt_teeth/core/routing/app_routes.dart';
import 'package:dt_teeth/core/theme/theme_bloc/theme_bloc.dart';
import 'package:dt_teeth/features/appointments/presentaion/pages/appointments_management_screen.dart';
import 'package:dt_teeth/features/auth/presentation/pages/login/login_screen.dart';
import 'package:dt_teeth/features/auth/presentation/pages/on_boarding/splash_screen.dart';
import 'package:dt_teeth/features/doctors/presentation/pages/doctors_screen.dart';
import 'package:dt_teeth/features/home/pages/patient_home_screen.dart';
import 'package:dt_teeth/features/home/widgets/patient_bottom_nav_bar.dart';
import 'package:dt_teeth/features/main_shell/pages/patient_main_shell_screen.dart';
import 'package:dt_teeth/features/medical_record/presentation/pages/medical_record_home_screen.dart';
import 'package:dt_teeth/features/profile/presentation/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements Storage {}

void runTestApp() {
  final storage = MockStorage();

  when<dynamic>(() => storage.read(any())).thenReturn(null);

  when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});

  when(() => storage.delete(any())).thenAnswer((_) async {});

  when(storage.clear).thenAnswer((_) async {});

  HydratedBloc.storage = storage;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => LocaleBloc()),
        BlocProvider(
          create: (_) => ConnectivityBloc(
            networkInfo: NetworkInfo(connectivity: Connectivity()),
          )..add(const ConnectivityStarted()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'IT-NAV-01 main patient shell and all bottom navigation destinations',
    (tester) async {
      runTestApp();

      // انتظار ظهور Splash.
      for (
        var attempt = 0;
        attempt < 30 && find.byType(SplashScreen).evaluate().isEmpty;
        attempt++
      ) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.byType(SplashScreen), findsOneWidget);

      // مهم: نترك Splash ينهي عمله الطبيعي وينتقل إلى Login،
      // حتى لا يبقى مؤقته فعالًا أثناء اختبار الـMain Shell.
      for (
        var attempt = 0;
        attempt < 80 && find.byType(LoginScreen).evaluate().isEmpty;
        attempt++
      ) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.byType(LoginScreen), findsOneWidget);

      // بعد انتهاء Splash بالكامل ننتقل إلى Home.
      AppRouter.router.go(AppRoutes.home);

      for (
        var attempt = 0;
        attempt < 40 && find.byType(PatientMainShellScreen).evaluate().isEmpty;
        attempt++
      ) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.byType(PatientMainShellScreen), findsOneWidget);

      expect(find.byType(PatientBottomNavBar), findsOneWidget);

      expect(find.byType(IndexedStack), findsOneWidget);

      final shellContext = tester.element(find.byType(PatientMainShellScreen));

      final l10n = shellContext.l10n;

      final labels = <String>[
        l10n.bottomNavHome,
        l10n.bottomNavDoctors,
        l10n.bottomNavAppointments,
        l10n.bottomNavMedicalRecord,
        l10n.bottomNavAccount,
      ];

      final expectedPages = <Type>[
        PatientHomeScreen,
        DoctorsScreen,
        AppointmentsManagementScreen,
        MedicalRecordHomeScreen,
        ProfileScreen,
      ];

      // التحقق من RTL/LTR.
      expect(
        Directionality.of(shellContext),
        Localizations.localeOf(shellContext).languageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
      );

      // التحقق من أسماء التبويبات.
      for (final label in labels) {
        expect(find.text(label), findsWidgets);
      }

      // التحقق من الصفحة الرئيسية في البداية.
      expect(
        tester
            .widget<PatientBottomNavBar>(find.byType(PatientBottomNavBar))
            .currentIndex,
        0,
      );

      expect(tester.widget<IndexedStack>(find.byType(IndexedStack)).index, 0);

      expect(find.byType(PatientHomeScreen), findsOneWidget);

      expect(tester.takeException(), isNull);

      // اختبار الأطباء، المواعيد، السجل الطبي، والحساب.
      for (var index = 1; index < expectedPages.length; index++) {
        final bottomNavBar = tester.widget<PatientBottomNavBar>(
          find.byType(PatientBottomNavBar),
        );

        bottomNavBar.onTap(index);

        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(PatientBottomNavBar), findsOneWidget);

        expect(
          tester
              .widget<PatientBottomNavBar>(find.byType(PatientBottomNavBar))
              .currentIndex,
          index,
        );

        expect(
          tester.widget<IndexedStack>(find.byType(IndexedStack)).index,
          index,
        );

        expect(find.byType(expectedPages[index]), findsOneWidget);

        expect(tester.takeException(), isNull);
      }

      // الرجوع إلى الصفحة الرئيسية.
      final bottomNavBar = tester.widget<PatientBottomNavBar>(
        find.byType(PatientBottomNavBar),
      );

      bottomNavBar.onTap(0);

      await tester.pump(const Duration(milliseconds: 500));

      expect(
        tester
            .widget<PatientBottomNavBar>(find.byType(PatientBottomNavBar))
            .currentIndex,
        0,
      );

      expect(tester.widget<IndexedStack>(find.byType(IndexedStack)).index, 0);

      expect(find.byType(PatientHomeScreen), findsOneWidget);

      expect(tester.takeException(), isNull);
    },
  );
}
