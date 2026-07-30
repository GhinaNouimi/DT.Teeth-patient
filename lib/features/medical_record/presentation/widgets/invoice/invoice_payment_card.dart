import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../domain/entities/invoice/invoice_payment_entity.dart';

class InvoicePaymentCard extends StatelessWidget {
  final InvoicePaymentEntity payment;

  const InvoicePaymentCard({
    super.key,
    required this.payment,
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

  String _formatDate(
      BuildContext context,
      String value,
      ) {
    if (value.trim().isEmpty) {
      return '-';
    }

    final parsedDate = DateTime.tryParse(value);

    if (parsedDate == null) {
      return value;
    }

    final languageCode =
        Localizations.localeOf(context).languageCode;

    return DateFormat(
      'dd/MM/yyyy',
      languageCode,
    ).format(parsedDate);
  }

  String _paymentMethodLabel(
      BuildContext context,
      ) {
    final l10n = context.l10n;

    switch (payment.paymentMethod) {
      case InvoicePaymentMethod.cash:
        return l10n.paymentMethodCash;

      case InvoicePaymentMethod.card:
        return l10n.paymentMethodCard;

      case InvoicePaymentMethod.unknown:
        return l10n.paymentMethodUnknown;
    }
  }

  IconData get _paymentMethodIcon {
    switch (payment.paymentMethod) {
      case InvoicePaymentMethod.cash:
        return Icons.payments_outlined;

      case InvoicePaymentMethod.card:
        return Icons.credit_card_rounded;

      case InvoicePaymentMethod.unknown:
        return Icons.help_outline_rounded;
    }
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.successBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _paymentMethodIcon,
              color: colors.successForeground,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatAmount(
                    context,
                    payment.amount,
                  ),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _paymentMethodLabel(context),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                l10n.paymentDate,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _formatDate(
                  context,
                  payment.paidAt,
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}