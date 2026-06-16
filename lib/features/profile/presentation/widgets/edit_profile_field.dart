import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';

class EditProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final TextInputType keyboardType;
  final int maxLines;

  const EditProfileField({
    super.key,
    required this.label,
    required this.controller,
    required this.enabled,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: colors.backgroundSecondary,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.borderSoft.withValues(alpha: 0.75),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: const InputDecorationTheme(
            filled: false,
            fillColor: Colors.transparent,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ),
        child: TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: theme.textTheme.titleSmall?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            labelText: label,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 8,
            ),
            labelStyle: theme.textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}