import 'package:dt_teeth/features/auth/presentation/pages/forget_password/password_match_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/auth/app_text_field.dart';
import '../../../../../core/widgets/auth/auth_shell.dart';
import '../../../../../core/widgets/auth/password_strength_card.dart';
import '../../../../../core/widgets/auth/primary_app_button.dart';
import '../../../../../core/widgets/feedback/success_bottom_sheet.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_refresh);
    _confirmPasswordController.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _passwordController.removeListener(_refresh);
    _confirmPasswordController.removeListener(_refresh);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء تأكيد كلمة المرور';
    }
    if (value != _passwordController.text) {
      return 'كلمتا المرور غير متطابقتين';
    }
    return null;
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await showSuccessBottomSheet(
        context,
        title: 'تم تحديث كلمة المرور',
        message: 'تمت إعادة تعيين كلمة المرور بنجاح.',
        buttonText: 'تسجيل الدخول',
        onPressed: () {
          context.go(AppRoutes.login);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: 'إعادة تعيين كلمة المرور',
      subtitle: 'أدخل كلمة مرور جديدة لحساب ${widget.email}',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            PasswordStrengthCard(
              password: _passwordController.text,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _passwordController,
              label: 'كلمة المرور الجديدة',
              hint: '********',
              prefixIcon: Icons.lock_reset_rounded,
              obscureText: true,
              validator: AppValidators.strongPassword,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _confirmPasswordController,
              label: 'تأكيد كلمة المرور',
              hint: '********',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: true,
              validator: _confirmPasswordValidator,
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 14),
            PasswordMatchCard(
              password: _passwordController.text,
              confirmPassword: _confirmPasswordController.text,
            ),
            const SizedBox(height: 20),
            PrimaryAppButton(
              text: 'حفظ كلمة المرور',
              icon: Icons.check_circle_outline_rounded,
              onPressed: _submit,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('رجوع'),
            ),
          ],
        ),
      ),
    );
  }
}
