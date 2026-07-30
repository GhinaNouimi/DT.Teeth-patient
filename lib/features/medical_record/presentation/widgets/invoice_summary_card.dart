import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/invoice/invoice_summary_entity.dart';
import '../utils/medical_record_accent.dart';

class InvoiceSummaryCard extends StatelessWidget {
  final InvoiceSummaryEntity summary;

  const InvoiceSummaryCard({
    super.key,
    required this.summary,
  });

  double get _progress {
    return summary.paymentProgress.clamp(0.0, 1.0);
  }

  String _formatAmount(
      BuildContext context,
      num amount,
      ) {
    final languageCode =
        Localizations.localeOf(context).languageCode;

    final formatter = NumberFormat.decimalPattern(
      languageCode,
    );

    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final accent = context.medicalAccent;
    final l10n = context.l10n;

    final progressPercent = (_progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.surfaceMuted,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.financialSummary,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _PrimaryAmount(
            label: l10n.totalAmount,
            value: _formatAmount(
              context,
              summary.totalAmount,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _AmountTile(
                  label: l10n.paidAmount,
                  amount: _formatAmount(
                    context,
                    summary.paidAmount,
                  ),
                  icon: Icons.check_circle_outline_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AmountTile(
                  label: l10n.remainingAmount,
                  amount: _formatAmount(
                    context,
                    summary.remainingAmount,
                  ),
                  icon: Icons.schedule_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.paymentProgress,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '$progressPercent%',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 10,
              backgroundColor: colors.surfaceMuted,
              color: accent,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: summary.isFullyPaid
                  ? colors.successBackground
                  : colors.infoBackground,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: summary.isFullyPaid
                    ? colors.successBorder
                    : colors.infoBorder,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  summary.isFullyPaid
                      ? Icons.verified_rounded
                      : Icons.info_outline_rounded,
                  size: 20,
                  color: summary.isFullyPaid
                      ? colors.successForeground
                      : colors.infoForeground,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    summary.isFullyPaid
                        ? l10n.fullyPaid
                        : l10n.paymentRemaining,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: summary.isFullyPaid
                          ? colors.successForeground
                          : colors.infoForeground,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),        ],
      ),
    );
  }
}

class _PrimaryAmount extends StatelessWidget {
  final String label;
  final String value;

  const _PrimaryAmount({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final accent = context.medicalAccent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: accent,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountTile extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;

  const _AmountTile({
    required this.label,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final accent = context.medicalAccent;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22,
            color: accent,
          ),
          const SizedBox(height: 12),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}