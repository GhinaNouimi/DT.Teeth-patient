import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  static const supportedLocales = [
    Locale('ar'),
    Locale('en'),
  ];

  static const defaultLocale = Locale('ar');

  static const localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  /// 👉 تحديد الاتجاه بناءً على اللغة
  static TextDirection getDirection(Locale locale) {
    return locale.languageCode == 'ar'
        ? TextDirection.rtl
        : TextDirection.ltr;
  }
}