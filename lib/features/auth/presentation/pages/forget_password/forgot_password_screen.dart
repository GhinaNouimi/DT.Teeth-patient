import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) async {
        if (state is ForgotPasswordSendCodeSuccess) {
          await showSuccessBottomSheet(
            context,
            title: 'تم إرسال الرمز',
            message: 'أرسلنا رمز التحقق إلى بريدك الإلكتروني.\nصلاحية الرمز دقيقتان.',
            buttonText: 'إدخال الرمز',
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
            title: 'فشل إرسال الرمز',
            message: state.message,
            buttonText: 'حسنًا',
          );
        }
      },
      child: AuthShell(
        title: 'نسيت كلمة المرور',
        subtitle: 'أدخل بريدك الإلكتروني لإرسال رمز التحقق',
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _emailController,
                label: 'البريد الإلكتروني',
                hint: 'name@example.com',
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: AppValidators.email,
              ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.08, end: 0),

              const SizedBox(height: 22),

              BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                builder: (context, state) {
                  final isLoading = state is ForgotPasswordLoading;

                  return PrimaryAppButton(
                    text: isLoading ? 'جاري إرسال الرمز...' : 'إرسال الرمز',
                    icon: Icons.mark_email_read_outlined,
                    onPressed: isLoading ? null : _submit,
                  );
                },
              ).animate().fadeIn(delay: 220.ms).slideY(begin: 0.14, end: 0),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () => context.pop(),
                child: const Text('العودة لتسجيل الدخول'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}