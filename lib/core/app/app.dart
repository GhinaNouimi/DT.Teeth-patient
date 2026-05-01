import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/locale_controller.dart';
import '../config/theme_controller.dart';
import '../routing/app_router.dart';
import '../theme/app_theme.dart';
import '../theme/theme_extensions.dart';
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

          locale: localeController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,

          builder: (context, child) {
            final colors = context.colors;
            final isDark = Theme.of(context).brightness == Brightness.dark;

            final overlayStyle = SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
              isDark ? Brightness.light : Brightness.dark,
              statusBarBrightness:
              isDark ? Brightness.dark : Brightness.light,
              systemNavigationBarColor: colors.background,
              systemNavigationBarIconBrightness:
              isDark ? Brightness.light : Brightness.dark,
              systemNavigationBarDividerColor: colors.background,
            );

            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: overlayStyle,
              child: Directionality(
                textDirection: AppLocalizations.getDirection(
                  localeController.locale,
                ),
                child: ColoredBox(
                  color: colors.background,
                  child: child!,
                ),
              ),
            );
          },

          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
