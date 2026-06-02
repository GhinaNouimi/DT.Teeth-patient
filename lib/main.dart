import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/app/app.dart';
import 'core/config/locale_controller.dart';
import 'core/config/theme_controller.dart';
import 'core/storage/secure_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final token = await SecureStorageService.getToken();
  debugPrint('APP START TOKEN: $token');

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