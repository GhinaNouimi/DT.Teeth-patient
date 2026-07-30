import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../domain/entities/invoice/invoice_item_entity.dart';

class InvoiceItemCard extends StatelessWidget {
  final InvoiceItemEntity item;

  const InvoiceItemCard({
    super.key,
    required this.item,
  });

  String _formatAmount(
      BuildContext context,
      num amount,
      ) {
    final languageCode =
        Localizations.localeOf(context).languageCode;

    return NumberFormat.decimalPattern(
      languageCode,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colors.infoBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: colors.infoForeground,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.description,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _InvoiceValueRow(
            label: l10n.unitPrice,
            value: _formatAmount(
              context,
              item.unitPrice,
            ),
          ),
          const SizedBox(height: 10),
          _InvoiceValueRow(
            label: l10n.discountPercentage,
            value: '${item.discountPercentage}%',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: Divider(height: 1),
          ),
          _InvoiceValueRow(
            label: l10n.finalPrice,
            value: _formatAmount(
              context,
              item.finalPrice,
            ),
            emphasized: true,
          ),
        ],
      ),
    );
  }
}

class _InvoiceValueRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasized;

  const _InvoiceValueRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: emphasized
                ? colors.successForeground
                : colors.textPrimary,
            fontWeight: emphasized
                ? FontWeight.w800
                : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}