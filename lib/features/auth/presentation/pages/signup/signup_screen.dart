import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_shell.dart';
import '../widgets/date_of_birth_field.dart';
import '../widgets/gender_selector_card.dart';
import '../widgets/password_strength_card.dart';
import '../widgets/primary_app_button.dart';

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
  final _birthDateController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  DateTime? _selectedBirthDate;
  String? _selectedGender;
  bool _showGenderError = false;

  static const List<String> _genderOptions = ['ذكر', 'أنثى'];

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
    _birthDateController.dispose();
    _addressController.dispose();
    _passwordController.removeListener(_passwordListener);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final initialDate = _selectedBirthDate ?? DateTime(now.year - 20, 1, 1);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1940),
      lastDate: DateTime(now.year - 5, now.month, now.day),
    );

    if (picked == null) return;

    setState(() {
      _selectedBirthDate = picked;
      _birthDateController.text =
          DateFormat('yyyy-MM-dd').format(picked);
    });
  }

  Future<void> _submit() async {
    final isFormValid = _formKey.currentState!.validate();
    final hasGender = _selectedGender != null;

    setState(() {
      _showGenderError = !hasGender;
    });

    if (!isFormValid || !hasGender) return;

    final basicRegisterData = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'password': _passwordController.text,
      'password_confirmation': _confirmPasswordController.text,
      'date_of_birth': _birthDateController.text.trim(),
      'gender': _selectedGender == 'ذكر' ? 1 : 2,
      'address': _addressController.text.trim(),
    };

    context.push(AppRoutes.patientHealthQuestions, extra: basicRegisterData);
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

            BirthDateField(
              controller: _birthDateController,
              onTap: _pickBirthDate,
              delay: 220.ms,
            ),

            const SizedBox(height: 16),

            GenderSelectorCard(
              selectedGender: _selectedGender,
              options: _genderOptions,
              showError: _showGenderError,
              onSelected: (value) {
                setState(() {
                  _selectedGender = value;
                  _showGenderError = false;
                });
              },
              delay: 260.ms,
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller: _addressController,
              label: 'العنوان',
              hint: 'أدخل عنوانك',
              prefixIcon: Icons.location_on_outlined,
              maxLines: 3,
              textInputAction: TextInputAction.newline,
              validator: (value) =>
                  AppValidators.requiredField(value, fieldName: 'العنوان'),
            ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.08, end: 0),

            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'شروط كلمة المرور',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),

            const SizedBox(height: 10),

            PasswordStrengthCard(
              password: _passwordController.text,
            ).animate().fadeIn(delay: 340.ms),

            const SizedBox(height: 16),

            AppTextField(
              controller: _passwordController,
              label: 'كلمة المرور',
              hint: '********',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: true,
              validator: AppValidators.strongPassword,
              onChanged: (_) => setState(() {}),
            ).animate().fadeIn(delay: 380.ms).slideX(begin: 0.08, end: 0),

            const SizedBox(height: 16),

            AppTextField(
              controller: _confirmPasswordController,
              label: 'تأكيد كلمة المرور',
              hint: '********',
              prefixIcon: Icons.lock_reset_rounded,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى تأكيد كلمة المرور';
                }

                if (value != _passwordController.text) {
                  return 'كلمة المرور غير متطابقة';
                }

                return null;
              },
            ).animate().fadeIn(delay: 420.ms).slideX(begin: 0.08, end: 0),

            const SizedBox(height: 20),

            PrimaryAppButton(
              text: 'متابعة',
              icon: Icons.arrow_forward_rounded,
              onPressed: _submit,
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.14, end: 0),
          ],
        ),
      ),
    );
  }
}
