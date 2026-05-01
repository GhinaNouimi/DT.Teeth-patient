import 'package:flutter/material.dart';

import '../widgets/home_section_title.dart';

class CenterOffersSection extends StatelessWidget {
  const CenterOffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionTitle(title: 'عروض خاصة'),
        const SizedBox(height: 14),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 280,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('خصم 20% على التبييض'),
                    SizedBox(height: 8),
                    Text('لفترة محدودة هذا الأسبوع'),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
