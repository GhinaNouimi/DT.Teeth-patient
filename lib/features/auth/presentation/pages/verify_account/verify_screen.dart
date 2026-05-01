import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/widgets/auth/auth_shell.dart';
import '../../../../../core/widgets/auth/primary_app_button.dart';

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
    if (_pinController.text.trim().length == 6) {
      // TODO: call verify usecase
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 58,
      height: 62,
      textStyle: Theme.of(context).textTheme.titleLarge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        color: Theme.of(context).colorScheme.surface,
      ),
    );

    return AuthShell(
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
          PrimaryAppButton(
            text: 'تأكيد الرمز',
            icon: Icons.verified_user_outlined,
            onPressed: _verify,
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
