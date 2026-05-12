import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../../../core/utils/validators.dart';
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
    return AppTextField(
      controller: controller,
      label: 'تاريخ الميلاد',
      hint: 'اختر تاريخ الميلاد',
      prefixIcon: Icons.calendar_today_outlined,
      readOnly: true,
      onTap: onTap,
      validator: (value) => AppValidators.requiredField(
        value,
        fieldName: 'تاريخ الميلاد',
      ),
    ).animate().fadeIn(delay: delay).slideX(begin: 0.08, end: 0);
  }
}
