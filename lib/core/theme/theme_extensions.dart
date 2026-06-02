import 'package:flutter/material.dart';
import 'app_color_tokens.dart';

extension ThemeContext on BuildContext {
  AppColorTokens get colors {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark
        ? AppColorTokens.dark
        : AppColorTokens.light;
  }

  TextTheme get text => Theme.of(this).textTheme;
}
