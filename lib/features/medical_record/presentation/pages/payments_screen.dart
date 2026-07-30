import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/offline_cached_banner.dart';
import '../../../../core/widgets/loading/app_skeleton.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../domain/entities/invoice/invoice_summary_entity.dart';
import '../../medical_record_di.dart';
import '../bloc/invoice/invoice_bloc.dart';
import '../bloc/invoice/invoice_event.dart';
import '../bloc/invoice/invoice_state.dart';
import '../widgets/medical_record_empty_state.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final languageCode =
        Localizations.localeOf(context).languageCode;

    return BlocProvider(
      create: (_) => InvoiceBloc(
        getInvoiceSummaryUseCase:
        MedicalRecordDi.getInvoiceSummaryUseCase,
        getInvoiceForTreatmentUseCase:
        MedicalRecordDi.getInvoiceForTreatmentUseCase,
      )..add(
        LoadInvoiceSummaryRequested(
          languageCode: languageCode,
        ),
      ),
      child: const _PaymentsView(),
    );
  }
}

class _PaymentsView extends StatelessWidget {
  const _PaymentsView();

  InvoiceSummaryEntity _fakeSummary() {
    return const InvoiceSummaryEntity(
      totalAmount: 1000000,
      paidAmount: 600000,
      remainingAmount: 400000,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                0,
              ),
              child: AppTopBar(
                title: l10n.financialPayments,
              ),
            ),
            Expanded(
              child: BlocBuilder<InvoiceBloc, InvoiceState>(
                builder: (context, state) {
                  final isLoading =
                      state is InvoiceInitial ||
                          state is InvoiceLoading;

                  if (state is InvoiceFailure) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: MedicalRecordEmptyState(
                        title: l10n.invoiceSummaryLoadFailed,
                        subtitle: state.message,
                        icon: Icons.account_balance_wallet_outlined,
                      ),
                    );
                  }

                  final summary =
                  state is InvoiceSummaryLoaded
                      ? state.summary
                      : _fakeSummary();

                  final isFromCache =
                      state is InvoiceSummaryLoaded &&
                          state.isFromCache;

                  final hasFinancialData =
                      summary.totalAmount > 0 ||
                          summary.paidAmount > 0 ||
                          summary.remainingAmount > 0;

                  return RefreshIndicator(
                    onRefresh: () async {
                      final languageCode =
                          Localizations.localeOf(context)
                              .languageCode;

                      context.read<InvoiceBloc>().add(
                        LoadInvoiceSummaryRequested(
                          languageCode: languageCode,
                        ),
                      );
                    },
                    child: AppSkeleton(
                      enabled: isLoading,
                      child: ListView(
                        physics:
                        const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          16,
                          20,
                          32,
                        ),
                        children: [
                          if (isFromCache) ...[
                            OfflineCachedBanner(
                              message:
                              l10n.offlineCachedDataMessage,
                            ),
                            const SizedBox(height: 16),
                          ],

                          if (!hasFinancialData && !isLoading)
                            MedicalRecordEmptyState(
                              title: l10n.noFinancialDataTitle,
                              subtitle:
                              l10n.noFinancialDataSubtitle,
                              icon: Icons
                                  .account_balance_wallet_outlined,
                            )
                          else ...[
                            _FinancialIntroductionCard(
                              summary: summary,
                            ),

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: _FinancialAmountCard(
                                    title: l10n.paidAmount,
                                    amount: summary.paidAmount,
                                    icon: Icons
                                        .check_circle_outline_rounded,
                                    status:
                                    _FinancialAmountStatus.paid,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _FinancialAmountCard(
                                    title:
                                    l10n.remainingAmount,
                                    amount:
                                    summary.remainingAmount,
                                    icon: Icons
                                        .schedule_rounded,
                                    status:
                                    _FinancialAmountStatus
                                        .remaining,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            _PaymentProgressCard(
                              summary: summary,
                            ),

                            const SizedBox(height: 18),

                            const _InvoiceDetailsHintCard(),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FinancialIntroductionCard extends StatelessWidget {
  final InvoiceSummaryEntity summary;

  const _FinancialIntroductionCard({
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: colors.infoBackground,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 26,
                  color: colors.infoForeground,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.financialSummary,
                      style:
                      theme.textTheme.titleLarge?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.financialOverviewSubtitle,
                      style:
                      theme.textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.totalAmount,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            _formatAmount(
              context,
              summary.totalAmount,
            ),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

enum _FinancialAmountStatus {
  paid,
  remaining,
}

class _FinancialAmountCard extends StatelessWidget {
  final String title;
  final num amount;
  final IconData icon;
  final _FinancialAmountStatus status;

  const _FinancialAmountCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    final isPaid =
        status == _FinancialAmountStatus.paid;

    final foregroundColor = isPaid
        ? colors.successForeground
        : colors.warningForeground;

    final backgroundColor = isPaid
        ? colors.successBackground
        : colors.warningBackground;

    return Container(
      constraints: const BoxConstraints(
        minHeight: 145,
      ),
      padding: const EdgeInsets.all(17),
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
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              size: 22,
              color: foregroundColor,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              _formatAmount(
                context,
                amount,
              ),
              style: theme.textTheme.titleLarge?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentProgressCard extends StatelessWidget {
  final InvoiceSummaryEntity summary;

  const _PaymentProgressCard({
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    final isFullyPaid = summary.isFullyPaid;

    final statusText = isFullyPaid
        ? l10n.fullyPaid
        : l10n.paymentRemaining;

    final statusForeground = isFullyPaid
        ? colors.successForeground
        : colors.warningForeground;

    final statusBackground = isFullyPaid
        ? colors.successBackground
        : colors.warningBackground;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.paymentProgress,
                  style:
                  theme.textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  statusText,
                  style:
                  theme.textTheme.bodySmall?.copyWith(
                    color: statusForeground,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${summary.paymentProgressPercent}%',
                style:
                theme.textTheme.headlineSmall?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              Text(
                '${_formatAmount(context, summary.paidAmount)}'
                    ' / '
                    '${_formatAmount(context, summary.totalAmount)}',
                style:
                theme.textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: summary.paymentProgress,
              minHeight: 10,
              backgroundColor: colors.surfaceMuted,
              color: statusForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceDetailsHintCard extends StatelessWidget {
  const _InvoiceDetailsHintCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.infoBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 24,
            color: colors.infoForeground,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.paymentDetailsHintTitle,
                  style:
                  theme.textTheme.titleSmall?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.paymentDetailsHintSubtitle,
                  style:
                  theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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