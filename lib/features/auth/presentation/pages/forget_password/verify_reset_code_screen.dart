import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/widgets/feedback/error_bottom_sheet.dart';
import '../../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../data/models/forgot_password_send_code_request_model.dart';
import '../../../data/models/forgot_password_verify_code_request_model.dart';
import '../../bloc/forgot_password/forgot_password_bloc.dart';
import '../../bloc/forgot_password/forgot_password_event.dart';
import '../../bloc/forgot_password/forgot_password_state.dart';
import '../widgets/auth_shell.dart';
import '../widgets/primary_app_button.dart';

class VerifyResetCodeScreen extends StatefulWidget {
  final String email;

  const VerifyResetCodeScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyResetCodeScreen> createState() => _VerifyResetCodeScreenState();
}

class _VerifyResetCodeScreenState extends State<VerifyResetCodeScreen> {
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = context.l10n;
    final code = _pinController.text.trim();

    if (code.length != 6) {
      showErrorBottomSheet(
        context,
        title: l10n.incompleteCodeTitle,
        message: l10n.incompleteCodeMessage,
        buttonText: l10n.ok,
      );
      return;
    }

    final request = ForgotPasswordVerifyCodeRequestModel(
      email: widget.email,
      verificationCode: code,
    );

    context.read<ForgotPasswordBloc>().add(
      VerifyForgotPasswordCodeSubmitted(request: request,languageCode: Localizations.localeOf(context).languageCode,),
    );
  }

  void _resendCode() {
    final request = ForgotPasswordSendCodeRequestModel(
      email: widget.email,
    );

    context.read<ForgotPasswordBloc>().add(
      SendForgotPasswordCodeSubmitted(request: request,languageCode: Localizations.localeOf(context).languageCode,),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 62,
      textStyle: theme.textTheme.titleLarge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outline),
        color: theme.colorScheme.surface.withValues(alpha: 0.82),
      ),
    );

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) async {
        if (state is ForgotPasswordVerifyCodeSuccess) {
          await showSuccessBottomSheet(
            context,
            title: l10n.codeVerifiedTitle,
            message: l10n.codeVerifiedMessage,
            buttonText: l10n.continueText,
            onPressed: () {
              context.push(AppRoutes.resetPassword, extra: widget.email);
            },
          );
        }

        if (state is ForgotPasswordSendCodeSuccess) {
          await showSuccessBottomSheet(
            context,
            title: l10n.codeSentTitle,
            message: l10n.newCodeSentMessage,
            buttonText: l10n.ok,
          );
        }

        if (state is ForgotPasswordFailure) {
          await showErrorBottomSheet(
            context,
            title: l10n.genericErrorTitle,
            message: state.message,
            buttonText: l10n.ok,
          );
        }
      },
      child: AuthShell(
        title: l10n.verifyCodeTitle,
        subtitle: l10n.verifyCodeSubtitle(widget.email),
        child: Column(
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Pinput(
                controller: _pinController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration?.copyWith(
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
              builder: (context, state) {
                final isLoading = state is ForgotPasswordLoading;

                return PrimaryAppButton(
                  text: isLoading ? l10n.verifying : l10n.verifyCodeButton,
                  icon: Icons.verified_user_outlined,
                  onPressed: isLoading ? null : _submit,
                );
              },
            ),
            const SizedBox(height: 12),
            BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
              builder: (context, state) {
                final isLoading = state is ForgotPasswordLoading;

                return TextButton(
                  onPressed: isLoading ? null : _resendCode,
                  child: Text(l10n.resendCode),
                );
              },
            ),
            TextButton(
              onPressed: () => context.pop(),
              child: Text(l10n.returnText),
            ),
          ],
        ),
      ),
    );
  }
}