import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ThemeChanged>(_onThemeChanged);
    on<ThemeToggled>(_onThemeToggled);
  }

  void _onThemeChanged(
      ThemeChanged event,
      Emitter<ThemeState> emit,
      ) {
    emit(state.copyWith(themeMode: event.themeMode));
  }

  void _onThemeToggled(
      ThemeToggled event,
      Emitter<ThemeState> emit,
      ) {
    final nextMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    emit(state.copyWith(themeMode: nextMode));
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    return ThemeState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return state.toJson();
  }
}