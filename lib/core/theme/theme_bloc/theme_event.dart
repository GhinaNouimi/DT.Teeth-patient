import 'package:flutter/material.dart';

sealed class ThemeEvent {
  const ThemeEvent();
}

final class ThemeChanged extends ThemeEvent {
  final ThemeMode themeMode;

  const ThemeChanged(this.themeMode);
}

final class ThemeToggled extends ThemeEvent {
  const ThemeToggled();
}