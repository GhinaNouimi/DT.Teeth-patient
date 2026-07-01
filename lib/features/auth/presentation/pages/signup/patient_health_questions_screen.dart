import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/feedback/error_bottom_sheet.dart';
import '../../../../../core/widgets/feedback/success_bottom_sheet.dart';
import '../../../data/models/register_patient_request_model.dart';
import '../../bloc/register/register_bloc.dart';
import '../../bloc/register/register_event.dart';
import '../../bloc/register/register_state.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_shell.dart';
import '../widgets/primary_app_button.dart';
import 'widgets/health_yes_no_question.dart';
import 'widgets/teeth_cleaning_selector.dart';

class PatientHealthQuestionsScreen extends StatefulWidget {
  final Map<String, dynamic> basicRegisterData;

  const PatientHealthQuestionsScreen({
    super.key,
    required this.basicRegisterData,
  });

  @override
  State<PatientHealthQuestionsScreen> createState() =>
      _PatientHealthQuestionsScreenState();
}

class _PatientHealthQuestionsScreenState
    extends State<PatientHealthQuestionsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emergencyNameController = TextEditingController();
  final _emergencyRelationController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  bool _isPregnant = false;
  bool _isBreastfeeding = false;
  bool _isSmoker = false;
  bool _drinksAlcoholFrequently = false;

  String _teethCleaningFrequency = 'twice';

  bool get _isFemale => widget.basicRegisterData['gender'] == 2;

  @override
  void dispose() {
    _emergencyNameController.dispose();
    _emergencyRelationController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final request = RegisterPatientRequestModel(
      name: widget.basicRegisterData['name'],
      email: widget.basicRegisterData['email'],
      phone: widget.basicRegisterData['phone'],
      password: widget.basicRegisterData['password'],
      passwordConfirmation: widget.basicRegisterData['password_confirmation'],
      dateOfBirth: widget.basicRegisterData['date_of_birth'],
      gender: widget.basicRegisterData['gender'],
      address: widget.basicRegisterData['address'],
      emergencyContactName: _emergencyNameController.text.trim(),
      emergencyContactRelation: _emergencyRelationController.text.trim(),
      emergencyContactPhone: _emergencyPhoneController.text.trim(),
      isPregnant: _isFemale ? _isPregnant : false,
      isBreastfeeding: _isFemale ? _isBreastfeeding : false,
      isSmoker: _isSmoker,
      drinksAlcoholFrequently: _drinksAlcoholFrequently,
      teethCleaningFrequency: _teethCleaningFrequency,
    );

    context.read<RegisterBloc>().add(
      RegisterPatientSubmitted(request: request),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) async {
        if (state is RegisterSuccess) {
          await showSuccessBottomSheet(
            context,
            title: l10n.accountCreatedSuccessfully,
            message: l10n.verificationCodeSent,
            buttonText: l10n.goToVerification,
          );

          if (!context.mounted) return;

          context.push(
            AppRoutes.verify,
            extra: widget.basicRegisterData['email'],
          );
        }

        if (state is RegisterFailure) {
          await showErrorBottomSheet(
            context,
            title: l10n.accountCreationFailed,
            message: state.message,
            buttonText: l10n.ok,
          );
        }
      },
      child: AuthShell(
        title: l10n.completePatientData,
        subtitle: l10n.patientHealthSubtitle,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _emergencyNameController,
                label: l10n.emergencyContactName,
                hint: l10n.emergencyContactNameHint,
                prefixIcon: Icons.person_outline_rounded,
                validator: (value) => AppValidators.requiredField(
                  value,
                  message: l10n.emergencyContactNameRequired,
                ),
              ).animate().fadeIn(delay: 60.ms).slideX(begin: 0.08, end: 0),

              const SizedBox(height: 16),

              AppTextField(
                controller: _emergencyRelationController,
                label: l10n.emergencyContactRelation,
                hint: l10n.emergencyContactRelationHint,
                prefixIcon: Icons.family_restroom_rounded,
                validator: (value) => AppValidators.requiredField(
                  value,
                  message: l10n.emergencyContactRelationRequired,
                ),
              ).animate().fadeIn(delay: 120.ms).slideX(begin: 0.08, end: 0),

              const SizedBox(height: 16),

              AppTextField(
                controller: _emergencyPhoneController,
                label: l10n.emergencyPhone,
                hint: '+963 ...',
                prefixIcon: Icons.phone_in_talk_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) => AppValidators.phone(
                  value,
                  requiredMessage: l10n.phoneRequired,
                  invalidMessage: l10n.phoneInvalid,
                ),
              ).animate().fadeIn(delay: 180.ms).slideX(begin: 0.08, end: 0),

              const SizedBox(height: 20),

              HealthYesNoQuestion(
                title: l10n.doYouSmoke,
                subtitle: l10n.smokingSubtitle,
                icon: Icons.smoking_rooms_outlined,
                value: _isSmoker,
                onChanged: (value) => setState(() => _isSmoker = value),
              ).animate().fadeIn(delay: 240.ms),

              const SizedBox(height: 12),

              HealthYesNoQuestion(
                title: l10n.drinkAlcohol,
                subtitle: l10n.alcoholSubtitle,
                icon: Icons.local_drink_outlined,
                value: _drinksAlcoholFrequently,
                onChanged: (value) {
                  setState(() => _drinksAlcoholFrequently = value);
                },
              ).animate().fadeIn(delay: 300.ms),

              if (_isFemale) ...[
                const SizedBox(height: 12),

                HealthYesNoQuestion(
                  title: l10n.isPregnant,
                  subtitle: l10n.pregnantSubtitle,
                  icon: Icons.pregnant_woman_rounded,
                  value: _isPregnant,
                  onChanged: (value) => setState(() => _isPregnant = value),
                ).animate().fadeIn(delay: 360.ms),

                const SizedBox(height: 12),

                HealthYesNoQuestion(
                  title: l10n.isBreastfeeding,
                  subtitle: l10n.breastfeedingSubtitle,
                  icon: Icons.child_friendly_rounded,
                  value: _isBreastfeeding,
                  onChanged: (value) {
                    setState(() => _isBreastfeeding = value);
                  },
                ).animate().fadeIn(delay: 420.ms),
              ],

              const SizedBox(height: 16),

              TeethCleaningSelector(
                value: _teethCleaningFrequency,
                onChanged: (value) {
                  setState(() => _teethCleaningFrequency = value);
                },
              ).animate().fadeIn(delay: 480.ms).slideX(begin: 0.08, end: 0),

              const SizedBox(height: 24),

              BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  final isLoading = state is RegisterLoading;

                  return PrimaryAppButton(
                    text: isLoading
                        ? l10n.creatingAccount
                        : l10n.createAccount,
                    icon: Icons.check_rounded,
                    onPressed: isLoading ? null : _submit,
                  );
                },
              ).animate().fadeIn(delay: 540.ms).slideY(begin: 0.14, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}