import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/auth/app_text_field.dart';
import '../../../../../core/widgets/auth/auth_shell.dart';
import '../../../../../core/widgets/auth/password_strength_card.dart';
import '../../../../../core/widgets/auth/primary_app_button.dart';
import '../../../../../core/widgets/feedback/success_bottom_sheet.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_passwordListener);
  }

  void _passwordListener() => setState(() {});

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.removeListener(_passwordListener);
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await showSuccessBottomSheet(
        context,
        title: 'تم إنشاء الحساب',
        message: 'تم إنشاء حسابك بنجاح، سننقلك الآن إلى شاشة التحقق من البريد الإلكتروني.',
        buttonText: 'متابعة',
        onPressed: () {
          context.push(AppRoutes.verify, extra: _emailController.text.trim());
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: 'إنشاء حساب',
      subtitle: 'أنشئ حسابك للوصول إلى مواعيدك وخدمات المركز',
      bottomText: 'لديك حساب بالفعل؟',
      bottomActionText: 'تسجيل الدخول',
      onBottomTap: () => context.go(AppRoutes.login),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextField(
              controller: _nameController,
              label: 'الاسم الكامل',
              hint: 'أدخل اسمك الكامل',
              prefixIcon: Icons.person_outline_rounded,
              validator: (value) =>
                  AppValidators.requiredField(value, fieldName: 'الاسم'),
            ).animate().fadeIn(delay: 60.ms).slideX(begin: 0.08, end: 0),

            const SizedBox(height: 16),

            AppTextField(
              controller: _phoneController,
              label: 'رقم الهاتف',
              hint: '+963 ...',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: AppValidators.phone,
            ).animate().fadeIn(delay: 120.ms).slideX(begin: 0.08, end: 0),

            const SizedBox(height: 16),

            AppTextField(
              controller: _emailController,
              label: 'البريد الإلكتروني',
              hint: 'name@example.com',
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: AppValidators.email,
            ).animate().fadeIn(delay: 180.ms).slideX(begin: 0.08, end: 0),

            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'شروط كلمة المرور',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 10),

            PasswordStrengthCard(
              password: _passwordController.text,
            ).animate().fadeIn(delay: 220.ms),

            const SizedBox(height: 16),

            AppTextField(
              controller: _passwordController,
              label: 'كلمة المرور',
              hint: '********',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: true,
              validator: AppValidators.strongPassword,
              onChanged: (_) => setState(() {}),
            ).animate().fadeIn(delay: 260.ms).slideX(begin: 0.08, end: 0),


            const SizedBox(height: 20),

            PrimaryAppButton(
              text: 'إنشاء الحساب',
              icon: Icons.person_add_alt_1_rounded,
              onPressed: _submit,
            ).animate().fadeIn(delay: 360.ms).slideY(begin: 0.14, end: 0),
          ],
        ),
      ),
    );
  }
}
