import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/feedback/error_bottom_sheet.dart';
import '../../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../data/models/login_request_model.dart';

import '../../bloc/login/login_bloc.dart';
import '../../bloc/login/login_event.dart';
import '../../bloc/login/login_state.dart';

import '../widgets/app_text_field.dart';
import '../widgets/auth_shell.dart';
import '../widgets/primary_app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final request = LoginRequestModel(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    context.read<LoginBloc>().add(LoginPatientSubmitted(request: request));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is LoginSuccess) {
          await showSuccessBottomSheet(
            context,
            title: 'تم تسجيل الدخول',
            message: 'تم تسجيل دخولك بنجاح. يمكنك الآن متابعة استخدام التطبيق.',
            buttonText: 'متابعة',
            onPressed: () {
              context.go(AppRoutes.home);
            },
          );
        }

        if (state is LoginFailure) {
          await showErrorBottomSheet(
            context,
            title: 'فشل تسجيل الدخول',
            message: state.message,
            buttonText: 'حسنًا',
          );
        }
      },
      child: AuthShell(
        title: 'تسجيل الدخول',
        subtitle: 'أدخل بياناتك للوصول إلى حسابك بسهولة وأمان',
        bottomText: 'ليس لديك حساب؟',
        bottomActionText: 'إنشاء حساب',
        onBottomTap: () => context.go(AppRoutes.signup),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _emailController,
                label: 'البريد الإلكتروني',
                hint: 'name@example.com',
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: AppValidators.email,
              ).animate().fadeIn(delay: 80.ms).slideX(begin: 0.08, end: 0),

              const SizedBox(height: 16),

              AppTextField(
                controller: _passwordController,
                label: 'كلمة المرور',
                hint: '********',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال كلمة المرور';
                  }

                  return null;
                },
              ).animate().fadeIn(delay: 180.ms).slideX(begin: 0.08, end: 0),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    context.push(AppRoutes.forgotPassword);
                  },
                  child: const Text('نسيت كلمة المرور؟'),
                ),
              ).animate().fadeIn(delay: 260.ms),

              const SizedBox(height: 8),

              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  final isLoading = state is LoginLoading;

                  return PrimaryAppButton(
                    text: isLoading ? 'جاري تسجيل الدخول...' : 'دخول',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: isLoading ? null : _submit,
                  );
                },
              ).animate().fadeIn(delay: 320.ms).slideY(begin: 0.14, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}