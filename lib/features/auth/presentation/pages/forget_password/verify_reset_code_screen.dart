import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/widgets/auth/auth_shell.dart';
import '../../../../../core/widgets/auth/primary_app_button.dart';
import '../../../../../core/widgets/feedback/success_bottom_sheet.dart';

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

  Future<void> _submit() async {
    if (_pinController.text.trim().length == 6) {
      await showSuccessBottomSheet(
        context,
        title: 'تم التحقق من الرمز',
        message: 'يمكنك الآن إعادة تعيين كلمة المرور.',
        buttonText: 'متابعة',
        onPressed: () {
          context.push(
            AppRoutes.resetPassword,
            extra: widget.email,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

    return AuthShell(
      title: 'التحقق من الرمز',
      subtitle: 'أدخل الرمز المرسل إلى ${widget.email}',
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
          PrimaryAppButton(
            text: 'تأكيد الرمز',
            icon: Icons.verified_user_outlined,
            onPressed: _submit,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {},
            child: const Text('إعادة إرسال الرمز'),
          ),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('العودة'),
          ),
        ],
      ),
    );
  }
}
