import 'package:flutter/material.dart';

import '../widgets/home_section_title.dart';
import '../widgets/specialty_tile.dart';

class SpecialtiesSection extends StatelessWidget {
  const SpecialtiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        HomeSectionTitle(title: 'تخصصات المركز'),
        SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SpecialtyTile(label: 'تقويم', icon: Icons.align_horizontal_left_rounded),
            SpecialtyTile(label: 'زراعة', icon: Icons.medical_services_outlined),
            SpecialtyTile(label: 'أطفال', icon: Icons.child_care_outlined),
            SpecialtyTile(label: 'تجميل', icon: Icons.auto_awesome_outlined),
          ],
        ),
      ],
    );
  }
}
