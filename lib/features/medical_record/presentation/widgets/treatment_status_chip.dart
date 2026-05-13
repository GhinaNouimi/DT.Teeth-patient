import 'package:flutter/material.dart';

import '../../../../core/theme/app_color_tokens.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/treatment_entity.dart';

class TreatmentStatusChip extends StatelessWidget {
  final TreatmentStatus status;
  final String label;

  const TreatmentStatusChip({
    super.key,
    required this.status,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = Theme.of(context).textTheme.labelMedium;
    final (background, foreground) = _colors(colors);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: style?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  (Color, Color) _colors(AppColorTokens colors) {
    switch (status) {
      case TreatmentStatus.active:
        return (colors.surfaceMuted, Colors.indigo);
      case TreatmentStatus.completed:
        return (colors.reservedState, colors.success);
      case TreatmentStatus.planned:
        return (colors.warning, const Color(0xFF9A5C00));
    }
  }
}
