import 'package:flutter/material.dart';

import 'core/app/app.dart';
import 'core/config/locale_controller.dart';
import 'core/config/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeController = ThemeController();
  await themeController.loadTheme();

  final localeController = LocaleController();
  await localeController.loadLocale();

  runApp(
    MyApp(
      themeController: themeController,
      localeController: localeController,
    ),
  );
}