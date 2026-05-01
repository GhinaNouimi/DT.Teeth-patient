import 'package:flutter/material.dart';

import '../widgets/home_section_title.dart';
import '../widgets/service_chip.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionTitle(title: 'بعض الخدمات'),
        SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ServiceChip(label: 'تنظيف الأسنان'),
            ServiceChip(label: 'تبييض'),
            ServiceChip(label: 'حشوات تجميلية'),
            ServiceChip(label: 'أشعة'),
            ServiceChip(label: 'زراعة الأسنان'),
          ],
        ),
      ],
    );
  }
}
