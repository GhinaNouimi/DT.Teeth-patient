import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';

class BookingBottomAction extends StatelessWidget {
  final bool isLastStep;
  final bool canContinue;
  final bool canSubmit;
  final bool isSubmitting;
  final VoidCallback onContinue;
  final VoidCallback onSubmit;

  const BookingBottomAction({
    super.key,
    required this.isLastStep,
    required this.canContinue,
    required this.canSubmit,
    required this.isSubmitting,
    required this.onContinue,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final isEnabled = isLastStep
        ? canSubmit && !isSubmitting
        : canContinue;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        18,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(
          top: BorderSide(
            color: colors.borderSoft,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: !isEnabled
              ? null
              : isLastStep
              ? onSubmit
              : onContinue,
          child: isSubmitting
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : Text(
              isLastStep
                  ? context.l10n.sendAppointmentRequestButton
                  : context.l10n.continueButton
          ),
        ),
      ),
    );
  }
}