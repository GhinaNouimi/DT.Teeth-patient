import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import 'offers_feedback_view.dart';

class OffersErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const OffersErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final normalizedMessage = message?.trim();

    final description =
    normalizedMessage != null &&
        normalizedMessage.isNotEmpty
        ? normalizedMessage
        : l10n.offersLoadErrorDescription;

    return OffersFeedbackView(
      icon: Icons.error_outline_rounded,
      title: l10n.offersLoadErrorTitle,
      description: description,
      buttonText: l10n.retryOffers,
      onPressed: onRetry,
    );
  }
}