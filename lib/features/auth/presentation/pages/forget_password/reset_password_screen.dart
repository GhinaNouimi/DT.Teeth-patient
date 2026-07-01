import 'package:dt_teeth/features/auth/presentation/pages/forget_password/password_match_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/feedback/error_bottom_sheet.dart';
import '../../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../data/models/forgot_password_reset_password_request_model.dart';
import '../../bloc/forgot_password/forgot_password_bloc.dart';
import '../../bloc/forgot_password/forgot_password_event.dart';
import '../../bloc/forgot_password/forgot_password_state.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_shell.dart';
import '../widgets/password_strength_card.dart';
import '../widgets/primary_app_button.dart';

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
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _confirmPasswordValidator(String? value) {
    final l10n = context.l10n;

    if (value == null || value.trim().isEmpty) {
      return l10n.confirmPasswordRequired;
    }

    if (value != _passwordController.text) {
      return l10n.passwordsNotMatching;
    }

    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final request = ForgotPasswordResetPasswordRequestModel(
      email: widget.email,
      password: _passwordController.text,
    );

    context.read<ForgotPasswordBloc>().add(
      ResetPasswordSubmitted(request: request),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) async {
        if (state is ForgotPasswordResetSuccess) {
          await showSuccessBottomSheet(
            context,
            title: l10n.passwordUpdatedTitle,
            message: l10n.passwordUpdatedMessage,
            buttonText: l10n.login,
            onPressed: () {
              context.go(AppRoutes.login);
            },
          );
        }

        if (state is ForgotPasswordFailure) {
          await showErrorBottomSheet(
            context,
            title: l10n.passwordUpdateFailedTitle,
            message: state.message,
            buttonText: l10n.ok,
          );
        }
      },
      child: AuthShell(
        title: l10n.resetPasswordTitle,
        subtitle: l10n.resetPasswordSubtitle(widget.email),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([
                  _passwordController,
                  _confirmPasswordController,
                ]),
                builder: (context, _) {
                  return Column(
                    children: [
                      PasswordStrengthCard(
                        password: _passwordController.text,
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
              AppTextField(
                controller: _passwordController,
                label: l10n.newPassword,
                hint: '********',
                prefixIcon: Icons.lock_reset_rounded,
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
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _confirmPasswordController,
                label: l10n.confirmPassword,
                hint: '********',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: true,
                validator: _confirmPasswordValidator,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 14),
              AnimatedBuilder(
                animation: Listenable.merge([
                  _passwordController,
                  _confirmPasswordController,
                ]),
                builder: (context, _) {
                  return PasswordMatchCard(
                    password: _passwordController.text,
                    confirmPassword: _confirmPasswordController.text,
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                builder: (context, state) {
                  final isLoading = state is ForgotPasswordLoading;

                  return PrimaryAppButton(
                    text: isLoading ? l10n.saving : l10n.savePassword,
                    icon: Icons.check_circle_outline_rounded,
                    onPressed: isLoading ? null : _submit,
                  );
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(l10n.back),
              ),
            ],
          ),
        ),
      ),
    );
  }
}