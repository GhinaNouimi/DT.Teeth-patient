import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/feedback/error_bottom_sheet.dart';
import '../../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../data/models/forgot_password_send_code_request_model.dart';
import '../../bloc/forgot_password/forgot_password_bloc.dart';
import '../../bloc/forgot_password/forgot_password_event.dart';
import '../../bloc/forgot_password/forgot_password_state.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_shell.dart';
import '../widgets/primary_app_button.dart';

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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final request = ForgotPasswordSendCodeRequestModel(
      email: _emailController.text.trim(),
    );

    context.read<ForgotPasswordBloc>().add(
      SendForgotPasswordCodeSubmitted(request: request),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) async {
        if (state is ForgotPasswordSendCodeSuccess) {
          await showSuccessBottomSheet(
            context,
            title: l10n.codeSentTitle,
            message: l10n.codeSentMessage,
            buttonText: l10n.enterCode,
            onPressed: () {
              context.push(
                AppRoutes.verifyResetCode,
                extra: _emailController.text.trim(),
              );
            },
          );
        }

        if (state is ForgotPasswordFailure) {
          await showErrorBottomSheet(
            context,
            title: l10n.sendCodeFailedTitle,
            message: state.message,
            buttonText: l10n.ok,
          );
        }
      },
      child: AuthShell(
        title: l10n.forgotPasswordTitle,
        subtitle: l10n.forgotPasswordSubtitle,
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
                validator: AppValidators.email,
              ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.08, end: 0),

              const SizedBox(height: 22),

              BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                builder: (context, state) {
                  final isLoading = state is ForgotPasswordLoading;

                  return PrimaryAppButton(
                    text: isLoading ? l10n.sendingCode : l10n.sendCode,
                    icon: Icons.mark_email_read_outlined,
                    onPressed: isLoading ? null : _submit,
                  );
                },
              ).animate().fadeIn(delay: 220.ms).slideY(begin: 0.14, end: 0),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () => context.pop(),
                child: Text(l10n.backToLogin),
              ),
            ],
          ),
        ),
      ),
    );
  }
}