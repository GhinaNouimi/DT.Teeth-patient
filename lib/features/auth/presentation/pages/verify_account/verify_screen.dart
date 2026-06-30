import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/widgets/feedback/error_bottom_sheet.dart';
import '../../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../data/models/send_verification_request_model.dart';
import '../../../data/models/verify_email_request_model.dart';
import '../../bloc/verify_email/verify_email_bloc.dart';
import '../../bloc/verify_email/verify_email_event.dart';
import '../../bloc/verify_email/verify_email_state.dart';
import '../widgets/auth_shell.dart';
import '../widgets/primary_app_button.dart';

class VerifyScreen extends StatefulWidget {
  final String email;

  const VerifyScreen({super.key, required this.email});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _verify() {
    final code = _pinController.text.trim();

    if (code.length != 6) {
      showErrorBottomSheet(
        context,
        title: 'رمز غير مكتمل',
        message: 'يرجى إدخال رمز تحقق مكون من 6 أرقام.',
        buttonText: 'حسنًا',
      );
      return;
    }

    final request = VerifyEmailRequestModel(
      email: widget.email,
      verificationCode: code,
    );

    context.read<VerifyEmailBloc>().add(
      VerifyEmailSubmitted(request: request),
    );
  }

  void _resendCode() {
    final request = SendVerificationRequestModel(email: widget.email);

    context.read<VerifyEmailBloc>().add(
      ResendVerificationSubmitted(request: request),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final defaultPinTheme = PinTheme(
      width: 58,
      height: 62,
      textStyle: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w800,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.45),
        ),
        color: theme.colorScheme.surface,
      ),
    );

    return BlocListener<VerifyEmailBloc, VerifyEmailState>(
      listener: (context, state) async {
        if (state is VerifyEmailSuccess) {
          await showSuccessBottomSheet(
            context,
            title: 'تم تأكيد الحساب',
            message: 'تم تأكيد حسابك بنجاح. يمكنك الآن استخدام التطبيق.',
            buttonText: 'متابعة',
            onPressed: () {
              context.go(AppRoutes.home);
            },
          );
        }

        if (state is VerifyEmailFailure) {
          await showErrorBottomSheet(
            context,
            title: 'فشل التحقق',
            message: state.message,
            buttonText: 'حسنًا',
          );
        }

        if (state is ResendVerificationSuccess) {
          await showSuccessBottomSheet(
            context,
            title: 'تم إرسال الرمز',
            message:
            'أرسلنا رمز تحقق جديد إلى بريدك الإلكتروني. الرمز صالح لمدة دقيقتين.',
            buttonText: 'حسنًا',
          );
        }

        if (state is ResendVerificationFailure) {
          await showErrorBottomSheet(
            context,
            title: 'فشل إرسال الرمز',
            message: state.message,
            buttonText: 'حسنًا',
          );
        }
      },
      child: AuthShell(
        title: 'تأكيد الحساب',
        subtitle: 'أدخل رمز التحقق المرسل إلى ${widget.email}',
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
                      width: 1.6,
                    ),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration?.copyWith(
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 1.4,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<VerifyEmailBloc, VerifyEmailState>(
              builder: (context, state) {
                final isLoading = state is VerifyEmailLoading;

                return PrimaryAppButton(
                  text: isLoading ? 'جاري التحقق...' : 'تأكيد الرمز',
                  icon: Icons.verified_user_outlined,
                  onPressed: isLoading ? null : _verify,
                );
              },
            ),
            const SizedBox(height: 12),
            BlocBuilder<VerifyEmailBloc, VerifyEmailState>(
              builder: (context, state) {
                final isLoading = state is ResendVerificationLoading;
                final isVerifyLoading = state is VerifyEmailLoading;

                return TextButton(
                  onPressed: isLoading || isVerifyLoading ? null : _resendCode,
                  child: Text(
                    isLoading ? 'جاري إرسال الرمز...' : 'إعادة إرسال الرمز',
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('العودة'),
            ),
          ],
        ),
      ),
    );
  }
}