import 'package:flutter/material.dart';

import '../../../../core/theme/app_color_tokens.dart';

class BookingTimeTile extends StatelessWidget {
  final String time;
  final bool isSelected;
  final AppColorTokens colors;

  const BookingTimeTile({
    super.key,
    required this.time,
    required this.isSelected,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
          colors: [
            colors.buttonPrimary,
            colors.buttonPrimary.withValues(alpha: 0.8),
          ],
        )
            : null,
        color: isSelected ? null : colors.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.transparent : colors.borderSoft,
          width: 2,
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: colors.buttonPrimary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule_rounded,
            color: isSelected ? Colors.white : colors.buttonPrimary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
