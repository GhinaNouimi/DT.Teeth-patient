import 'package:flutter/material.dart';

import '../../../../core/theme/app_color_tokens.dart';
import '../widgets/doctor_section_title.dart';

class DoctorContactSection extends StatelessWidget {
  final String phone;
  final AppColorTokens colors;
  final ThemeData theme;
  final VoidCallback onPhoneTap;

  const DoctorContactSection({
    super.key,
    required this.phone,
    required this.colors,
    required this.theme,
    required this.onPhoneTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DoctorSectionTitle(title: 'التواصل', theme: theme, colors: colors),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.surfaceMuted,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.phone_rounded, color: colors.buttonPrimary, size: 24),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'رقم الهاتف',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: onPhoneTap,
                    child: Text(
                      phone,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
