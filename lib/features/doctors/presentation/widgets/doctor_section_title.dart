import 'package:flutter/material.dart';

import '../../../../core/theme/app_color_tokens.dart';

class DoctorSectionTitle extends StatelessWidget {
  final String title;
  final ThemeData theme;
  final AppColorTokens colors;

  const DoctorSectionTitle({
    super.key,
    required this.title,
    required this.theme,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w800,
        color: colors.textPrimary,
      ),
    );
  }
}
