import 'package:flutter/material.dart';

import '../config/locale_controller.dart';
import '../config/theme_controller.dart';
import '../routing/app_router.dart';
import '../theme/app_theme.dart';
import '../localization/app_localizations.dart';

class MyApp extends StatelessWidget {
  final ThemeController themeController;
  final LocaleController localeController;

  const MyApp({
    super.key,
    required this.themeController,
    required this.localeController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([themeController, localeController]),
      builder: (context, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,

          // 🌍 اللغة
          locale: localeController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates:
          AppLocalizations.localizationsDelegates,

          // 🔁 الاتجاه
          builder: (context, child) {
            return Directionality(
              textDirection: AppLocalizations.getDirection(
                  localeController.locale),
              child: child!,
            );
          },

          // 🎨 الثيم
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,

          // 🚀 router
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}