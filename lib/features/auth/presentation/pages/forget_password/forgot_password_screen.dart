import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/auth/app_text_field.dart';
import '../../../../../core/widgets/auth/auth_shell.dart';
import '../../../../../core/widgets/auth/primary_app_button.dart';
import '../../../../../core/widgets/feedback/success_bottom_sheet.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await showSuccessBottomSheet(
        context,
        title: 'تم إرسال الرمز',
        message: 'أرسلنا رمز التحقق إلى بريدك الإلكتروني.',
        buttonText: 'إدخال الرمز',
        onPressed: () {
          context.push(
            AppRoutes.verifyResetCode,
            extra: _emailController.text.trim(),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: 'نسيت كلمة المرور',
      subtitle: 'أدخل بريدك الإلكتروني لإرسال رمز التحقق',
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
            ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.08, end: 0),
            const SizedBox(height: 22),
            PrimaryAppButton(
              text: 'إرسال الرمز',
              icon: Icons.mark_email_read_outlined,
              onPressed: _submit,
            ).animate().fadeIn(delay: 220.ms).slideY(begin: 0.14, end: 0),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('العودة لتسجيل الدخول'),
            ),
          ],
        ),
      ),
    );
  }
}
