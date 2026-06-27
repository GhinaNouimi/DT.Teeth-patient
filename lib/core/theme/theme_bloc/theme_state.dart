import 'package:flutter/material.dart';

class ThemeState {
  final ThemeMode themeMode;

  const ThemeState({
    required this.themeMode,
  });

  factory ThemeState.initial() {
    return const ThemeState(themeMode: ThemeMode.light);
  }

  ThemeState copyWith({
    ThemeMode? themeMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.name,
    };
  }

  factory ThemeState.fromJson(Map<String, dynamic> json) {
    final value = json['themeMode'] as String?;

    return ThemeState(
      themeMode: ThemeMode.values.firstWhere(
            (mode) => mode.name == value,
        orElse: () => ThemeMode.light,
      ),
    );
  }
}