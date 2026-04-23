import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/auth/app_text_field.dart';
import '../../../../core/widgets/auth/auth_shell.dart';
import '../../../../core/widgets/auth/primary_app_button.dart';

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
    if (_formKey.currentState!.validate()) {
      // TODO: call login usecase
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
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
                onPressed: () => context.push(AppRoutes.forgotPassword),
                child: const Text('نسيت كلمة المرور؟'),
              ),
            ).animate().fadeIn(delay: 260.ms),

            const SizedBox(height: 8),

            PrimaryAppButton(
              text: 'دخول',
              icon: Icons.arrow_forward_rounded,
              onPressed: _submit,
            ).animate().fadeIn(delay: 320.ms).slideY(begin: 0.14, end: 0),
          ],
        ),
      ),
    );
  }
}
