import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'locale_event.dart';
import 'locale_state.dart';

class LocaleBloc extends HydratedBloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(LocaleState.initial()) {
    on<LocaleChanged>(_onLocaleChanged);
    on<LanguageChanged>(_onLanguageChanged);
  }

  void _onLocaleChanged(
      LocaleChanged event,
      Emitter<LocaleState> emit,
      ) {
    emit(state.copyWith(locale: _safeLocale(event.locale.languageCode)));
  }

  void _onLanguageChanged(
      LanguageChanged event,
      Emitter<LocaleState> emit,
      ) {
    emit(state.copyWith(locale: _safeLocale(event.languageCode)));
  }

  Locale _safeLocale(String languageCode) {
    return Locale(languageCode == 'en' ? 'en' : 'ar');
  }

  @override
  LocaleState? fromJson(Map<String, dynamic> json) {
    return LocaleState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(LocaleState state) {
    return state.toJson();
  }
}