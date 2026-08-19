import 'package:dt_teeth/core/app/app.dart';
import 'package:dt_teeth/core/localization/app_localizations.dart';
import 'package:dt_teeth/core/localization/locale_bloc/locale_bloc.dart';
import 'package:dt_teeth/core/theme/theme_bloc/theme_bloc.dart';
import 'package:dt_teeth/features/auth/presentation/pages/forget_password/forgot_password_screen.dart';
import 'package:dt_teeth/features/auth/presentation/pages/login/login_screen.dart';
import 'package:dt_teeth/features/auth/presentation/pages/on_boarding/splash_screen.dart';
import 'package:dt_teeth/features/auth/presentation/pages/signup/signup_screen.dart';
import 'package:dt_teeth/features/auth/presentation/pages/widgets/primary_app_button.dart';
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
      ],
      child: const MyApp(),
    ),
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'IT-AUTH-01 app launch, validation, password visibility, and auth navigation',
    (tester) async {
      // تشغيل التطبيق باستخدام تخزين مؤقت سريع خاص بالاختبار.
      runTestApp();

      // انتظار ظهور شاشة البداية الخاصة بالتطبيق.
      for (
        var attempt = 0;
        attempt < 20 && find.byType(SplashScreen).evaluate().isEmpty;
        attempt++
      ) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // 1. التحقق من أن التطبيق بدأ من شاشة Splash الحقيقية.
      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.text('DT.Teeth'), findsOneWidget);

      // 2. انتظار مؤقت Splash والانتقال إلى Login.
      await tester.pump(const Duration(milliseconds: 3700));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(LoginScreen), findsOneWidget);

      final loginContext = tester.element(find.byType(LoginScreen));
      final l10n = loginContext.l10n;

      // التحقق من اتجاه الواجهة حسب اللغة الحالية.
      expect(
        Directionality.of(loginContext),
        Localizations.localeOf(loginContext).languageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
      );

      // 3. إرسال النموذج فارغًا والتحقق من رسائل الخطأ.
      await tester.ensureVisible(find.byType(PrimaryAppButton));
      await tester.tap(find.byType(PrimaryAppButton));
      await tester.pump();

      expect(find.text(l10n.emailRequired), findsOneWidget);
      expect(find.text(l10n.passwordRequired), findsOneWidget);
      expect(find.byType(LoginScreen), findsOneWidget);

      // 4. إدخال بريد غير صالح وكلمة مرور غير فارغة.
      final fields = find.byType(TextFormField);

      expect(fields, findsNWidgets(2));

      await tester.enterText(fields.at(0), 'invalid-email');
      await tester.enterText(fields.at(1), 'Secret123!');

      await tester.tap(find.byType(PrimaryAppButton));
      await tester.pump();

      expect(find.text(l10n.emailInvalid), findsOneWidget);
      expect(find.text(l10n.passwordRequired), findsNothing);

      // 5. التحقق من إخفاء كلمة المرور افتراضيًا.
      expect(find.byIcon(Icons.visibility_rounded), findsOneWidget);

      expect(
        tester
            .widget<EditableText>(find.byType(EditableText).at(1))
            .obscureText,
        isTrue,
      );

      // الضغط على زر إظهار كلمة المرور.
      await tester.tap(find.byIcon(Icons.visibility_rounded));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byIcon(Icons.visibility_off_rounded), findsOneWidget);

      expect(
        tester
            .widget<EditableText>(find.byType(EditableText).at(1))
            .obscureText,
        isFalse,
      );

      // 6. الانتقال الحقيقي من Login إلى Signup.
      await tester.ensureVisible(find.text(l10n.createAccount));
      await tester.tap(find.text(l10n.createAccount));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(SignupScreen), findsOneWidget);

      // 7. العودة من Signup إلى Login باستخدام زر Login الحقيقي.
      final signupContext = tester.element(find.byType(SignupScreen));
      final signupL10n = signupContext.l10n;

      await tester.ensureVisible(find.text(signupL10n.login));
      await tester.tap(find.text(signupL10n.login));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(LoginScreen), findsOneWidget);

      // 8. الانتقال من Login إلى Forgot Password.
      final restoredContext = tester.element(find.byType(LoginScreen));
      final restoredL10n = restoredContext.l10n;

      await tester.ensureVisible(
        find.text(restoredL10n.forgotPasswordQuestion),
      );

      await tester.tap(find.text(restoredL10n.forgotPasswordQuestion));

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
