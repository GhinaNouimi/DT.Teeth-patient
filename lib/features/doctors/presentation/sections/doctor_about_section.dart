import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_color_tokens.dart';
import '../widgets/doctor_section_title.dart';

class DoctorAboutSection extends StatelessWidget {
  final String bio;
  final AppColorTokens colors;
  final ThemeData theme;

  const DoctorAboutSection({
    super.key,
    required this.bio,
    required this.colors,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DoctorSectionTitle(
          title: l10n.aboutDoctor,
          theme: theme,
          colors: colors,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surfaceMuted,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            bio,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textPrimary,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}