import 'package:flutter/material.dart';

import '../../../../core/theme/app_color_tokens.dart';
import '../../../../core/theme/theme_extensions.dart';

class TreatmentStatusChip extends StatelessWidget {
  final String status;

  const TreatmentStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = Theme.of(context).textTheme.labelMedium;
    final label = _localizedLabel(context);
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

  String _localizedLabel(BuildContext context) {
    final isArabic =
    Localizations.localeOf(context).languageCode.toLowerCase().startsWith(
      'ar',
    );

    switch (status) {
      case 'completed':
        return isArabic ? 'مكتمل' : 'Completed';
      case 'pending':
        return isArabic ? 'قيد الانتظار' : 'Pending';
      case 'in_progress':
        return isArabic ? 'قيد العلاج' : 'In progress';
      case 'cancelled':
        return isArabic ? 'ملغى' : 'Cancelled';
      default:
        return status;
    }
  }

  (Color, Color) _colors(AppColorTokens colors) {
    switch (status) {
      case 'completed':
        return (colors.reservedState, colors.success);
      case 'pending':
        return (colors.warning, const Color(0xFF9A5C00));
      case 'in_progress':
        return (colors.surfaceMuted, Colors.indigo);
      default:
        return (colors.surfaceMuted, colors.navBarItem);
    }
  }
}