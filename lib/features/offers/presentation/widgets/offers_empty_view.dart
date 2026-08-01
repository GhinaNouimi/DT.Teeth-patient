import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import 'offers_feedback_view.dart';

class OffersEmptyView extends StatelessWidget {
  final VoidCallback onRefresh;

  const OffersEmptyView({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return OffersFeedbackView(
      icon: Icons.local_offer_outlined,
      title: l10n.offersEmptyTitle,
      description:
      l10n.offersEmptyDescription,
      buttonText: l10n.refreshOffers,
      onPressed: onRefresh,
    );
  }
}