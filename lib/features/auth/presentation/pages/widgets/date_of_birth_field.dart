import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/utils/validators.dart';
import 'app_text_field.dart';

class BirthDateField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  final Duration delay;

  const BirthDateField({
    super.key,
    required this.controller,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppTextField(
      controller: controller,
      label: l10n.birthDate,
      hint: l10n.birthDateHint,
      prefixIcon: Icons.calendar_today_outlined,
      readOnly: true,
      onTap: onTap,
      validator: (value) => AppValidators.requiredField(
        value,
        message: l10n.birthDateRequired,
      ),
    ).animate().fadeIn(delay: delay).slideX(begin: 0.08, end: 0);
  }
}