import 'package:flutter/material.dart';

import 'generated/app_localizations.g.dart';

abstract final class AppLocalizations {
  static const defaultLocale = Locale('ar');

  static const supportedLocales = GeneratedAppLocalizations.supportedLocales;

  static const localizationsDelegates =
      GeneratedAppLocalizations.localizationsDelegates;

  static TextDirection getDirection(Locale locale) {
    return locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
  }
}

extension AppLocalizationsX on BuildContext {
  GeneratedAppLocalizations get l10n => GeneratedAppLocalizations.of(this);
}
