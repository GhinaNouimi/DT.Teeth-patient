import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../core/widgets/branding/app_tooth_logo.dart';
import '../../../core/widgets/branding/dental_smile_mark.dart';
import '../widgets/home_section_title.dart';

class PatientHomeAppBarSection extends StatelessWidget {
  const PatientHomeAppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Row(
      children: [
        SizedBox(
          width: 54,
          height: 54,
          child: const AppToothLogo(size: 48)
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'DT.Teeth',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 8),
              const DentalSmileMark(),
            ],
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {},
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.borderSoft),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: colors.navBarItem,
                  ),
                ),
                PositionedDirectional(
                  top: 10,
                  end: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colors.buttonPrimary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
