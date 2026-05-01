import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../widgets/home_section_title.dart';

class CenterAddressSection extends StatelessWidget {
  const CenterAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionTitle(title: 'عنوان المركز'),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colors.surfacePrimary,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: colors.borderSoft),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.surfaceMuted,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: colors.navBarItem,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'دمشق - المزة - بناء المركز الطبي - الطابق الثاني',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
