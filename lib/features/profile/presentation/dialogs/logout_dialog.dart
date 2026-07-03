import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';

Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
  final colors = context.colors;
  final l10n = context.l10n;

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.logoutConfirmationTitle),
      content: Text(l10n.logoutConfirmationMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: colors.danger,
            foregroundColor: colors.textInverse,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.logoutButton),
        ),
      ],
    ),
  );

  return result ?? false;
}