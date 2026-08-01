import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/offer_entity.dart';
import '../widgets/offer_details_block.dart';

class OfferInformationSection extends StatelessWidget {
  final OfferEntity offer;

  const OfferInformationSection({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OfferDetailsBlock(
          icon: Icons.calendar_month_outlined,
          title: l10n.offerPeriodTitle,
          child: _OfferPeriodContent(
            startDate: offer.startDate,
            endDate: offer.endDate,
          ),
        ),
        if (offer.treatmentTypes.isNotEmpty) ...[
          const SizedBox(height: 14),
          OfferDetailsBlock(
            icon: Icons.medical_services_outlined,
            title: l10n.includedTreatmentsTitle,
            child: _IncludedTreatmentTypes(
              offer: offer,
            ),
          ),
        ],
        if (offer.conditions.trim().isNotEmpty) ...[
          const SizedBox(height: 14),
          OfferDetailsBlock(
            icon: Icons.rule_rounded,
            title: l10n.offerConditionsTitle,
            child: _ConditionsText(
              conditions: offer.conditions,
            ),
          ),
        ],
      ],
    );
  }
}

class _OfferPeriodContent extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  const _OfferPeriodContent({
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: _DateItem(
            label: l10n.offerStartsOn,
            date: startDate,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DateItem(
            label: l10n.offerEndsOn,
            date: endDate,
          ),
        ),
      ],
    );
  }
}

class _DateItem extends StatelessWidget {
  final String label;
  final DateTime? date;

  const _DateItem({
    required this.label,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    final formattedDate = date == null
        ? context.l10n.notAvailable
        : MaterialLocalizations.of(
      context,
    ).formatMediumDate(date!);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            formattedDate,
            style:
            theme.textTheme.titleSmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _IncludedTreatmentTypes extends StatelessWidget {
  final OfferEntity offer;

  const _IncludedTreatmentTypes({
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    final languageCode =
        Localizations.localeOf(context).languageCode;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: offer.treatmentTypes.map((type) {
        return _TreatmentTypeChip(
          label: type.localizedName(
            languageCode,
          ),
        );
      }).toList(),
    );
  }
}

class _TreatmentTypeChip extends StatelessWidget {
  final String label;

  const _TreatmentTypeChip({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.borderSoft,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 17,
            color: colors.success,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style:
            theme.textTheme.bodySmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConditionsText extends StatelessWidget {
  final String conditions;

  const _ConditionsText({
    required this.conditions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsetsDirectional.only(
            top: 8,
          ),
          decoration: BoxDecoration(
            color: colors.navBarItem,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            conditions,
            style:
            theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              height: 1.65,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}