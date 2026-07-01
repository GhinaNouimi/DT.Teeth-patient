import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/localization/app_localizations.dart';
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
  String? _selectedGenderCode;
  bool _showGenderError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
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
      _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    });
  }

  Future<void> _submit() async {
    final isFormValid = _formKey.currentState!.validate();
    final hasGender = _selectedGenderCode != null;

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
      'gender': _selectedGenderCode == 'male' ? 1 : 2,
      'address': _addressController.text.trim(),
    };

    if (!mounted) return;
    context.push(AppRoutes.patientHealthQuestions, extra: basicRegisterData);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final genderOptions = [
      l10n.male,
      l10n.female,
    ];

    final selectedGenderLabel = switch (_selectedGenderCode) {
      'male' => l10n.male,
      'female' => l10n.female,
      _ => null,
    };

    return AuthShell(
      title: l10n.signupTitle,
      subtitle: l10n.signupSubtitle,
      bottomText: l10n.alreadyHaveAccount,
      bottomActionText: l10n.login,
      onBottomTap: () => context.go(AppRoutes.login),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextField(
              controller: _nameController,
              label: l10n.fullName,
              hint: l10n.fullNameHint,
              prefixIcon: Icons.person_outline_rounded,
              validator: (value) => AppValidators.requiredField(
                value,
                message: l10n.nameRequired,
              ),
            ).animate().fadeIn(delay: 60.ms).slideX(begin: 0.08, end: 0),

            const SizedBox(height: 16),

            AppTextField(
              controller: _phoneController,
              label: l10n.phoneNumber,
              hint: '+963 ...',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) => AppValidators.phone(
                value,
                requiredMessage: l10n.phoneRequired,
                invalidMessage: l10n.phoneInvalid,
              ),
            ).animate().fadeIn(delay: 120.ms).slideX(begin: 0.08, end: 0),

            const SizedBox(height: 16),

            AppTextField(
              controller: _emailController,
              label: l10n.email,
              hint: l10n.emailHint,
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => AppValidators.email(
                value,
                requiredMessage: l10n.emailRequired,
                invalidMessage: l10n.emailInvalid,
              ),
            ).animate().fadeIn(delay: 180.ms).slideX(begin: 0.08, end: 0),

            const SizedBox(height: 16),

            BirthDateField(
              controller: _birthDateController,
              onTap: _pickBirthDate,
              delay: 220.ms,
            ),

            const SizedBox(height: 16),

            GenderSelectorCard(
              selectedGender: selectedGenderLabel,
              options: genderOptions,
              showError: _showGenderError,
              onSelected: (value) {
                setState(() {
                  _selectedGenderCode = value == l10n.male ? 'male' : 'female';
                  _showGenderError = false;
                });
              },
              delay: 260.ms,
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller: _addressController,
              label: l10n.address,
              hint: l10n.addressHint,
              prefixIcon: Icons.location_on_outlined,
              maxLines: 3,
              textInputAction: TextInputAction.newline,
              validator: (value) => AppValidators.requiredField(
                value,
                message: l10n.addressRequired,
              ),
            ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.08, end: 0),

            const SizedBox(height: 16),

            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                l10n.passwordRules,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 10),

            AnimatedBuilder(
              animation: _passwordController,
              builder: (context, _) {
                return PasswordStrengthCard(
                  password: _passwordController.text,
                ).animate().fadeIn(delay: 340.ms);
              },
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller: _passwordController,
              label: l10n.password,
              hint: '********',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: true,
              validator: (value) => AppValidators.strongPassword(
                value,
                requiredMessage: l10n.passwordRequired,
                minLengthMessage: l10n.passwordMinLength,
                uppercaseMessage: l10n.passwordUppercase,
                lowercaseMessage: l10n.passwordLowercase,
                numberMessage: l10n.passwordNumber,
                specialCharacterMessage: l10n.passwordSpecial,
              ),
            ).animate().fadeIn(delay: 380.ms).slideX(begin: 0.08, end: 0),

            const SizedBox(height: 16),

            AppTextField(
              controller: _confirmPasswordController,
              label: l10n.confirmPassword,
              hint: '********',
              prefixIcon: Icons.lock_reset_rounded,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.passwordConfirmationRequired;
                }

                if (value != _passwordController.text) {
                  return l10n.passwordsDoNotMatch;
                }

                return null;
              },
            ).animate().fadeIn(delay: 420.ms).slideX(begin: 0.08, end: 0),

            const SizedBox(height: 20),

            PrimaryAppButton(
              text: l10n.continueText,
              icon: Icons.arrow_forward_rounded,
              onPressed: _submit,
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.14, end: 0),
          ],
        ),
      ),
    );
  }
}