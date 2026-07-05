import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_color_tokens.dart';
import '../widgets/doctor_info_card.dart';

class DoctorInfoCardsSection extends StatelessWidget {
  final int yearsOfExperience;
  final AppColorTokens colors;
  final ThemeData theme;

  const DoctorInfoCardsSection({
    super.key,
    required this.yearsOfExperience,
    required this.colors,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DoctorInfoCard(
      title: l10n.yearsOfExperience,
      value: l10n.yearsValue(yearsOfExperience),
      icon: Icons.work_rounded,
      colors: colors,
      theme: theme,
    );
  }
}