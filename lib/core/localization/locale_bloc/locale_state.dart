import 'package:flutter/material.dart';

class LocaleState {
  final Locale locale;

  const LocaleState({
    required this.locale,
  });

  factory LocaleState.initial() {
    return const LocaleState(locale: Locale('ar'));
  }

  LocaleState copyWith({
    Locale? locale,
  }) {
    return LocaleState(
      locale: locale ?? this.locale,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languageCode': locale.languageCode,
    };
  }

  factory LocaleState.fromJson(Map<String, dynamic> json) {
    final languageCode = json['languageCode'] as String?;

    return LocaleState(
      locale: Locale(
        languageCode == 'en' ? 'en' : 'ar',
      ),
    );
  }
}