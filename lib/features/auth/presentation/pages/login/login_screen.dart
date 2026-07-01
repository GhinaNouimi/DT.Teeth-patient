import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/app_localizations.dart';
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
    final l10n = context.l10n;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is LoginSuccess) {
          await showSuccessBottomSheet(
            context,
            title: l10n.loginSuccessTitle,
            message: l10n.loginSuccessMessage,
            buttonText: l10n.continueText,
            onPressed: () {
              context.go(AppRoutes.home);
            },
          );
        }

        if (state is LoginFailure) {
          await showErrorBottomSheet(
            context,
            title: l10n.loginFailedTitle,
            message: state.message,
            buttonText: l10n.ok,
          );
        }
      },
      child: AuthShell(
        title: l10n.loginTitle,
        subtitle: l10n.loginSubtitle,
        bottomText: l10n.doNotHaveAccount,
        bottomActionText: l10n.createAccount,
        onBottomTap: () => context.go(AppRoutes.signup),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
              ).animate().fadeIn(delay: 80.ms).slideX(begin: 0.08, end: 0),

              const SizedBox(height: 16),

              AppTextField(
                controller: _passwordController,
                label: l10n.password,
                hint: '********',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.passwordRequired;
                  }

                  return null;
                },
              ).animate().fadeIn(delay: 180.ms).slideX(begin: 0.08, end: 0),

              const SizedBox(height: 10),

              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () {
                    context.push(AppRoutes.forgotPassword);
                  },
                  child: Text(l10n.forgotPasswordQuestion),
                ),
              ).animate().fadeIn(delay: 260.ms),

              const SizedBox(height: 8),

              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  final isLoading = state is LoginLoading;

                  return PrimaryAppButton(
                    text: isLoading ? l10n.loggingIn : l10n.loginButton,
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