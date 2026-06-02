import 'package:dt_teeth/features/auth/presentation/pages/forget_password/password_match_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء تأكيد كلمة المرور';
    }

    if (value != _passwordController.text) {
      return 'كلمتا المرور غير متطابقتين';
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
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) async {
        if (state is ForgotPasswordResetSuccess) {
          await showSuccessBottomSheet(
            context,
            title: 'تم تحديث كلمة المرور',
            message:
            'تمت إعادة تعيين كلمة المرور بنجاح. يمكنك الآن تسجيل الدخول بكلمة المرور الجديدة.',
            buttonText: 'تسجيل الدخول',
            onPressed: () {
              context.go(AppRoutes.login);
            },
          );
        }

        if (state is ForgotPasswordFailure) {
          await showErrorBottomSheet(
            context,
            title: 'فشل تحديث كلمة المرور',
            message: state.message,
            buttonText: 'حسنًا',
          );
        }
      },
      child: AuthShell(
        title: 'إعادة تعيين كلمة المرور',
        subtitle: 'أدخل كلمة مرور جديدة لحساب ${widget.email}',
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
                label: 'كلمة المرور الجديدة',
                hint: '********',
                prefixIcon: Icons.lock_reset_rounded,
                obscureText: true,
                validator: AppValidators.strongPassword,
              ),

              const SizedBox(height: 16),

              AppTextField(
                controller: _confirmPasswordController,
                label: 'تأكيد كلمة المرور',
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
                    text: isLoading ? 'جاري الحفظ...' : 'حفظ كلمة المرور',
                    icon: Icons.check_circle_outline_rounded,
                    onPressed: isLoading ? null : _submit,
                  );
                },
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () => context.pop(),
                child: const Text('رجوع'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}