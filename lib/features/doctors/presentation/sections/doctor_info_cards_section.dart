import 'package:flutter/material.dart';

import '../../../../core/theme/app_color_tokens.dart';
import '../widgets/doctor_info_card.dart';

class DoctorInfoCardsSection extends StatelessWidget {
  final int yearsOfExperience;
  final int treatedPatients;
  final AppColorTokens colors;
  final ThemeData theme;

  const DoctorInfoCardsSection({
    super.key,
    required this.yearsOfExperience,
    required this.treatedPatients,
    required this.colors,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DoctorInfoCard(
          title: 'سنين الخبرة',
          value: '$yearsOfExperience سنة',
          icon: Icons.work_rounded,
          colors: colors,
          theme: theme,
        ),
        const SizedBox(height: 12),
        DoctorInfoCard(
          title: 'المرضى المعالجين',
          value: '$treatedPatients+ مريض',
          icon: Icons.people_rounded,
          colors: colors,
          theme: theme,
        ),
      ],
    );
  }
}
