import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_color_tokens.dart';
import '../../../../core/theme/theme_extensions.dart';

class TreatmentStatusChip extends StatelessWidget {
  final String status;

  const TreatmentStatusChip({
    super.key,
    required this.status,
  });

  String get _normalizedStatus => status.trim().toLowerCase();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = Theme.of(context).textTheme.labelMedium;
    final label = _localizedLabel(context);
    final (background, foreground, border) = _colors(colors);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: border,
        ),
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
    final l10n = context.l10n;

    switch (_normalizedStatus) {
      case 'ongoing':
        return l10n.treatmentStatusOngoing;

      case 'completed':
        return l10n.treatmentStatusCompleted;

      case 'cancelled':
        return l10n.treatmentStatusCancelled;

      default:
        return l10n.treatmentStatusUnknown;
    }
  }

  (Color, Color, Color) _colors(
      AppColorTokens colors,
      ) {
    switch (_normalizedStatus) {
      case 'ongoing':
        return (
        colors.infoBackground,
        colors.infoForeground,
        colors.infoBorder,
        );

      case 'completed':
        return (
        colors.successBackground,
        colors.successForeground,
        colors.successBorder,
        );

      case 'cancelled':
        return (
        colors.dangerBackground,
        colors.dangerForeground,
        colors.dangerBorder,
        );

      default:
        return (
        colors.surfaceMuted,
        colors.textSecondary,
        colors.borderSoft,
        );
    }
  }
}