import 'package:flutter/material.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../domain/entities/invoice/treatment_invoice_entity.dart';

class InvoiceStatusChip extends StatelessWidget {
  final InvoiceStatus status;

  const InvoiceStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    late final String label;
    late final Color backgroundColor;
    late final Color foregroundColor;
    late final Color borderColor;
    late final IconData icon;

    switch (status) {
      case InvoiceStatus.paid:
        label = l10n.invoiceStatusPaid;
        backgroundColor = colors.successBackground;
        foregroundColor = colors.successForeground;
        borderColor = colors.successBorder;
        icon = Icons.check_circle_outline_rounded;
        break;

      case InvoiceStatus.partial:
        label = l10n.invoiceStatusPartial;
        backgroundColor = colors.warningBackground;
        foregroundColor = colors.warningForeground;
        borderColor = colors.warningBorder;
        icon = Icons.timelapse_rounded;
        break;

      case InvoiceStatus.unpaid:
        label = l10n.invoiceStatusUnpaid;
        backgroundColor = colors.dangerBackground;
        foregroundColor = colors.dangerForeground;
        borderColor = colors.dangerBorder;
        icon = Icons.error_outline_rounded;
        break;

      case InvoiceStatus.unknown:
        label = l10n.invoiceStatusUnknown;
        backgroundColor = colors.infoBackground;
        foregroundColor = colors.infoForeground;
        borderColor = colors.infoBorder;
        icon = Icons.info_outline_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 17,
            color: foregroundColor,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}