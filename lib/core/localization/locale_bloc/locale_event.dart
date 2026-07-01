import 'package:flutter/material.dart';

sealed class LocaleEvent {
  const LocaleEvent();
}

final class LocaleChanged extends LocaleEvent {
  final Locale locale;

  const LocaleChanged(this.locale);
}

final class LanguageChanged extends LocaleEvent {
  final String languageCode;

  const LanguageChanged(this.languageCode);
}