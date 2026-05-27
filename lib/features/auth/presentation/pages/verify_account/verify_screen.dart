import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/storage/secure_storage_service.dart';
import '../../../../../core/widgets/feedback/error_bottom_sheet.dart';
import '../../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../data/models/verify_email_request_model.dart';
import '../../bloc/verify_email/verify_email_bloc.dart';
import '../../bloc/verify_email/verify_email_event.dart';
import '../../bloc/verify_email/verify_email_state.dart';
import '../widgets/auth_shell.dart';
import '../widgets/primary_app_button.dart';

class VerifyScreen extends StatefulWidget {
  final String email;

  const VerifyScreen({
    super.key,
    required this.email,
  });

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال رمز مكون من 6 أرقام'),
        ),
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

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 58,
      height: 62,
      textStyle: Theme.of(context).textTheme.titleLarge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
        color: Theme.of(context).colorScheme.surface,
      ),
    );

    return BlocListener<VerifyEmailBloc, VerifyEmailState>(
      listener: (context, state) async {
        if (state is VerifyEmailSuccess) {
          await SecureStorageService.saveToken(
            token: state.response.token,
            tokenType: state.response.tokenType,
          );

          if (!context.mounted) return;

          await showSuccessBottomSheet(
            context,
            title: 'تم تأكيد الحساب',
            message: state.response.message,
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
      },      child: AuthShell(
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
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.6,
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
            TextButton(
              onPressed: () {
                // سنربط إعادة إرسال الرمز لاحقًا
              },
              child: const Text('إعادة إرسال الرمز'),
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