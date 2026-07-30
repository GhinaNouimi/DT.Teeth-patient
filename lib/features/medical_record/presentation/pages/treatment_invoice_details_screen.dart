import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/feedback/offline_cached_banner.dart';
import '../../../../core/widgets/loading/app_skeleton.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../domain/entities/invoice/invoice_item_entity.dart';
import '../../domain/entities/invoice/invoice_payment_entity.dart';
import '../../domain/entities/invoice/treatment_invoice_entity.dart';
import '../../medical_record_di.dart';
import '../bloc/invoice/invoice_bloc.dart';
import '../bloc/invoice/invoice_event.dart';
import '../bloc/invoice/invoice_state.dart';
import '../widgets/invoice/invoice_status_chip.dart';
import '../widgets/medical_record_empty_state.dart';

class TreatmentInvoiceDetailsScreen extends StatelessWidget {
  final int treatmentId;

  const TreatmentInvoiceDetailsScreen({
    super.key,
    required this.treatmentId,
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
        LoadTreatmentInvoiceRequested(
          treatmentId: treatmentId,
          languageCode: languageCode,
        ),
      ),
      child: _TreatmentInvoiceDetailsView(
        treatmentId: treatmentId,
      ),
    );
  }
}

class _TreatmentInvoiceDetailsView extends StatelessWidget {
  final int treatmentId;

  const _TreatmentInvoiceDetailsView({
    required this.treatmentId,
  });

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
                title: l10n.treatmentInvoiceDetails,
              ),
            ),
            Expanded(
              child: BlocBuilder<InvoiceBloc, InvoiceState>(
                builder: (context, state) {
                  if (state is InvoiceFailure) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: MedicalRecordEmptyState(
                        title:
                        l10n.treatmentInvoiceLoadFailed,
                        subtitle: state.message,
                        icon:
                        Icons.receipt_long_outlined,
                      ),
                    );
                  }

                  if (state is TreatmentInvoiceLoaded) {
                    return _InvoiceContent(
                      invoice: state.invoice,
                      isFromCache: state.isFromCache,
                      treatmentId: treatmentId,
                    );
                  }

                  return const _InvoiceLoadingSkeleton();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InvoiceContent extends StatelessWidget {
  final TreatmentInvoiceEntity invoice;
  final bool isFromCache;
  final int treatmentId;

  const _InvoiceContent({
    required this.invoice,
    required this.isFromCache,
    required this.treatmentId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return RefreshIndicator(
      onRefresh: () async {
        final languageCode =
            Localizations.localeOf(context).languageCode;

        context.read<InvoiceBloc>().add(
          LoadTreatmentInvoiceRequested(
            treatmentId: treatmentId,
            languageCode: languageCode,
          ),
        );
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
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
              message: l10n.offlineCachedDataMessage,
            ),
            const SizedBox(height: 16),
          ],

          _InvoiceHeaderCard(
            invoice: invoice,
          ),

          const SizedBox(height: 26),

          _SectionHeader(
            title: l10n.costDetails,
            icon: Icons.list_alt_rounded,
            itemCount: invoice.items.length,
          ),

          const SizedBox(height: 12),

          if (invoice.items.isEmpty)
            MedicalRecordEmptyState(
              title: l10n.noInvoiceItemsTitle,
              subtitle: l10n.noInvoiceItemsSubtitle,
              icon: Icons.receipt_long_outlined,
            )
          else
            _InvoiceItemsCard(
              items: invoice.items,
              totalAmount: invoice.totalAmount,
            ),

          const SizedBox(height: 26),

          _SectionHeader(
            title: l10n.paymentHistory,
            icon: Icons.history_rounded,
            itemCount: invoice.payments.length,
          ),

          const SizedBox(height: 12),

          if (invoice.payments.isEmpty)
            _EmptyPaymentsCard(
              remainingAmount: invoice.remainingAmount,
              isPaid: invoice.isPaid,
            )
          else
            _PaymentsTimeline(
              payments: invoice.payments,
            ),
        ],
      ),
    );
  }
}

class _InvoiceHeaderCard extends StatelessWidget {
  final TreatmentInvoiceEntity invoice;

  const _InvoiceHeaderCard({
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    final languageCode =
        Localizations.localeOf(context).languageCode;

    final treatmentTypeName =
    invoice.treatmentType.localizedName(
      languageCode,
    );

    final hasRemainingAmount =
        invoice.remainingAmount > 0;

    return Container(
      width: double.infinity,
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
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colors.infoBackground,
                  borderRadius:
                  BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  size: 27,
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
                      treatmentTypeName,
                      style: theme
                          .textTheme.titleLarge
                          ?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons
                              .person_outline_rounded,
                          size: 18,
                          color:
                          colors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            invoice.dentistName,
                            style: theme
                                .textTheme.bodyMedium
                                ?.copyWith(
                              color: colors
                                  .textSecondary,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              InvoiceStatusChip(
                status: invoice.status,
              ),
            ],
          ),

          const SizedBox(height: 22),

          Divider(
            height: 1,
            color: colors.borderSoft,
          ),

          const SizedBox(height: 20),

          _PrimaryTotalAmount(
            amount: invoice.totalAmount,
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _CompactAmountCard(
                  label: l10n.paidAmount,
                  amount: invoice.paidAmount,
                  icon: Icons
                      .check_circle_outline_rounded,
                  foregroundColor:
                  colors.successForeground,
                  backgroundColor:
                  colors.successBackground,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CompactAmountCard(
                  label: l10n.remainingAmount,
                  amount: invoice.remainingAmount,
                  icon: hasRemainingAmount
                      ? Icons.schedule_rounded
                      : Icons
                      .verified_outlined,
                  foregroundColor:
                  hasRemainingAmount
                      ? colors
                      .warningForeground
                      : colors
                      .successForeground,
                  backgroundColor:
                  hasRemainingAmount
                      ? colors
                      .warningBackground
                      : colors
                      .successBackground,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _InvoicePaymentProgress(
            invoice: invoice,
          ),
        ],
      ),
    );
  }
}

class _PrimaryTotalAmount extends StatelessWidget {
  final num amount;

  const _PrimaryTotalAmount({
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.totalTreatmentCost,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment:
          AlignmentDirectional.centerStart,
          child: Text(
            _formatAmount(context, amount),
            style:
            theme.textTheme.headlineMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _CompactAmountCard extends StatelessWidget {
  final String label;
  final num amount;
  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;

  const _CompactAmountCard({
    required this.label,
    required this.amount,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Container(
      constraints: const BoxConstraints(
        minHeight: 118,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius:
              BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 19,
              color: foregroundColor,
            ),
          ),
          const SizedBox(height: 11),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment:
            AlignmentDirectional.centerStart,
            child: Text(
              _formatAmount(
                context,
                amount,
              ),
              style:
              theme.textTheme.titleMedium?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoicePaymentProgress extends StatelessWidget {
  final TreatmentInvoiceEntity invoice;

  const _InvoicePaymentProgress({
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    final progressForeground =
    invoice.isPaid
        ? colors.successForeground
        : colors.infoForeground;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.paymentProgress,
                  style: theme
                      .textTheme.bodyMedium
                      ?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${invoice.paymentProgressPercent}%',
                style: theme
                    .textTheme.titleMedium
                    ?.copyWith(
                  color: progressForeground,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          ClipRRect(
            borderRadius:
            BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: invoice.paymentProgress,
              minHeight: 10,
              backgroundColor:
              colors.surfacePrimary,
              color: progressForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final int itemCount;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: colors.infoBackground,
            borderRadius:
            BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            size: 20,
            color: colors.infoForeground,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            title,
            style:
            theme.textTheme.titleLarge?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Container(
          constraints:
          const BoxConstraints(minWidth: 30),
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: colors.surfaceMuted,
            borderRadius:
            BorderRadius.circular(30),
          ),
          child: Text(
            itemCount.toString(),
            textAlign: TextAlign.center,
            style:
            theme.textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _InvoiceItemsCard extends StatelessWidget {
  final List<InvoiceItemEntity> items;
  final num totalAmount;

  const _InvoiceItemsCard({
    required this.items,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        children: [
          for (
          int index = 0;
          index < items.length;
          index++
          ) ...[
            _InvoiceItemRow(
              item: items[index],
            ),
            if (index != items.length - 1)
              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                child: Divider(
                  height: 1,
                  color: colors.borderSoft,
                ),
              ),
          ],

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: Divider(
              height: 1,
              color: colors.borderSoft,
              thickness: 1.2,
            ),
          ),

          _InvoiceItemsTotalRow(
            totalAmount: totalAmount,
          ),
        ],
      ),
    );
  }
}

class _InvoiceItemRow extends StatelessWidget {
  final InvoiceItemEntity item;

  const _InvoiceItemRow({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              borderRadius:
              BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.medical_services_outlined,
              size: 21,
              color: colors.infoForeground,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.description,
                        style: theme
                            .textTheme.titleSmall
                            ?.copyWith(
                          color: colors.textPrimary,
                          fontWeight:
                          FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _formatAmount(
                        context,
                        item.finalPrice,
                      ),
                      style: theme
                          .textTheme.titleSmall
                          ?.copyWith(
                        color: colors.textPrimary,
                        fontWeight:
                        FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                if (item.hasDiscount) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _PriceDetailChip(
                        label: l10n.basePrice,
                        value: _formatAmount(
                          context,
                          item.unitPrice,
                        ),
                      ),
                      _PriceDetailChip(
                        label: l10n.discount,
                        value:
                        '${_formatPercentage(item.discountPercentage)}%',
                        highlighted: true,
                      ),
                      _PriceDetailChip(
                        label:
                        l10n.discountAmount,
                        value: _formatAmount(
                          context,
                          item.discountAmount,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceDetailChip extends StatelessWidget {
  final String label;
  final String value;
  final bool highlighted;

  const _PriceDetailChip({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: highlighted
            ? colors.successBackground
            : colors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: $value',
        style: theme.textTheme.bodySmall?.copyWith(
          color: highlighted
              ? colors.successForeground
              : colors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InvoiceItemsTotalRow extends StatelessWidget {
  final num totalAmount;

  const _InvoiceItemsTotalRow({
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.totalAmount,
              style:
              theme.textTheme.titleMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            _formatAmount(
              context,
              totalAmount,
            ),
            style:
            theme.textTheme.titleLarge?.copyWith(
              color: colors.infoForeground,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentsTimeline extends StatelessWidget {
  final List<InvoicePaymentEntity> payments;

  const _PaymentsTimeline({
    required this.payments,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        children: [
          for (
          int index = 0;
          index < payments.length;
          index++
          ) ...[
            _PaymentTimelineItem(
              payment: payments[index],
              isLast:
              index == payments.length - 1,
            ),
          ],
        ],
      ),
    );
  }
}

class _PaymentTimelineItem extends StatelessWidget {
  final InvoicePaymentEntity payment;
  final bool isLast;

  const _PaymentTimelineItem({
    required this.payment,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final l10n = context.l10n;
    final languageCode =
        Localizations.localeOf(context).languageCode;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 34,
            child: Column(
              children: [
                const SizedBox(height: 18),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color:
                    colors.successForeground,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                      colors.successBackground,
                      width: 4,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: colors.borderSoft,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _formatPaymentDate(
                            context,
                            payment.paidAt,
                          ),
                          style: theme
                              .textTheme.bodyMedium
                              ?.copyWith(
                            color: colors
                                .textSecondary,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatAmount(
                          context,
                          payment.amount,
                        ),
                        style: theme
                            .textTheme.titleMedium
                            ?.copyWith(
                          color: colors
                              .successForeground,
                          fontWeight:
                          FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons
                            .payments_outlined,
                        size: 18,
                        color:
                        colors.textSecondary,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        l10n.paymentMethod,
                        style: theme
                            .textTheme.bodySmall
                            ?.copyWith(
                          color: colors
                              .textSecondary,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          payment.paymentMethod.localizedName(languageCode),
                          style: theme
                              .textTheme.bodyMedium
                              ?.copyWith(
                            color:
                            colors.textPrimary,
                            fontWeight:
                            FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPaymentsCard extends StatelessWidget {
  final num remainingAmount;
  final bool isPaid;

  const _EmptyPaymentsCard({
    required this.remainingAmount,
    required this.isPaid,
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
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: isPaid
                  ? colors.successBackground
                  : colors.warningBackground,
              borderRadius:
              BorderRadius.circular(20),
            ),
            child: Icon(
              isPaid
                  ? Icons
                  .verified_outlined
                  : Icons.payments_outlined,
              size: 29,
              color: isPaid
                  ? colors.successForeground
                  : colors.warningForeground,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            isPaid
                ? l10n.invoiceFullyPaidTitle
                : l10n.noPaymentsTitle,
            textAlign: TextAlign.center,
            style:
            theme.textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            isPaid
                ? l10n.invoiceFullyPaidSubtitle
                : l10n.noPaymentsSubtitle,
            textAlign: TextAlign.center,
            style:
            theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          if (!isPaid) ...[
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: colors.warningBackground,
                borderRadius:
                BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.remainingAmount,
                    style: theme
                        .textTheme.bodySmall
                        ?.copyWith(
                      color:
                      colors.warningForeground,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _formatAmount(
                      context,
                      remainingAmount,
                    ),
                    style: theme
                        .textTheme.titleLarge
                        ?.copyWith(
                      color:
                      colors.warningForeground,
                      fontWeight:
                      FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InvoiceLoadingSkeleton extends StatelessWidget {
  const _InvoiceLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppSkeleton(
      enabled: true,
      child: ListView(
        physics:
        const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          20,
          16,
          20,
          32,
        ),
        children: [
          Container(
            height: 360,
            decoration: BoxDecoration(
              color: colors.surfacePrimary,
              borderRadius:
              BorderRadius.circular(30),
            ),
          ),
          const SizedBox(height: 26),
          Container(
            width: 180,
            height: 38,
            decoration: BoxDecoration(
              color: colors.surfacePrimary,
              borderRadius:
              BorderRadius.circular(13),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: colors.surfacePrimary,
              borderRadius:
              BorderRadius.circular(26),
            ),
          ),
          const SizedBox(height: 26),
          Container(
            width: 180,
            height: 38,
            decoration: BoxDecoration(
              color: colors.surfacePrimary,
              borderRadius:
              BorderRadius.circular(13),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: colors.surfacePrimary,
              borderRadius:
              BorderRadius.circular(26),
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

  return NumberFormat.decimalPattern(
    languageCode,
  ).format(amount);
}

String _formatPercentage(num percentage) {
  if (percentage == percentage.roundToDouble()) {
    return percentage.toInt().toString();
  }

  return percentage.toStringAsFixed(1);
}

String _formatPaymentDate(
    BuildContext context,
    String dateValue,
    ) {
  final languageCode =
      Localizations.localeOf(context).languageCode;

  final parsedDate = DateTime.tryParse(dateValue);

  if (parsedDate == null) {
    return dateValue;
  }

  return DateFormat(
    'dd MMM yyyy',
    languageCode,
  ).format(parsedDate);
}