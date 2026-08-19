import 'package:dt_teeth/core/config/locale_controller.dart';
import 'package:dt_teeth/core/config/theme_controller.dart';
import 'package:dt_teeth/core/localization/locale_bloc/locale_state.dart';
import 'package:dt_teeth/core/theme/theme_bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

  test(
    'UT-SET-01 locale defaults to Arabic when no preference exists',
    () async {
      final controller = LocaleController();
      await controller.loadLocale();
      expect(controller.locale.languageCode, 'ar');
    },
  );

  test('UT-SET-02 loadLocale restores saved English language', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{'lang': 'en'});
    final controller = LocaleController();
    await controller.loadLocale();
    expect(controller.locale.languageCode, 'en');
  });

  test(
    'UT-SET-03 changeLanguage updates memory, storage, and listeners',
    () async {
      final controller = LocaleController();
      var notifications = 0;
      controller.addListener(() => notifications++);
      await controller.changeLanguage('en');
      final prefs = await SharedPreferences.getInstance();
      expect(controller.locale.languageCode, 'en');
      expect(prefs.getString('lang'), 'en');
      expect(notifications, 1);
    },
  );

  test('UT-SET-04 theme defaults to light without saved preference', () async {
    final controller = ThemeController();
    await controller.loadTheme();
    expect(controller.themeMode, ThemeMode.light);
  });

  test('UT-SET-05 loadTheme restores dark preference', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{'isDark': true});
    final controller = ThemeController();
    await controller.loadTheme();
    expect(controller.themeMode, ThemeMode.dark);
  });

  test('UT-SET-06 toggleTheme persists dark then light', () async {
    final controller = ThemeController();
    await controller.toggleTheme();
    var prefs = await SharedPreferences.getInstance();
    expect(controller.themeMode, ThemeMode.dark);
    expect(prefs.getBool('isDark'), isTrue);
    await controller.toggleTheme();
    prefs = await SharedPreferences.getInstance();
    expect(controller.themeMode, ThemeMode.light);
    expect(prefs.getBool('isDark'), isFalse);
  });

  test(
    'UT-SET-07 LocaleState serializes English and rejects unsupported locale',
    () {
      const english = LocaleState(locale: Locale('en'));
      expect(english.toJson(), <String, dynamic>{'languageCode': 'en'});
      expect(LocaleState.fromJson(english.toJson()).locale.languageCode, 'en');
      expect(
        LocaleState.fromJson(<String, dynamic>{
          'languageCode': 'fr',
        }).locale.languageCode,
        'ar',
      );
    },
  );

  test('UT-SET-08 ThemeState round-trip and invalid fallback are safe', () {
    const dark = ThemeState(themeMode: ThemeMode.dark);
    expect(ThemeState.fromJson(dark.toJson()).themeMode, ThemeMode.dark);
    expect(
      ThemeState.fromJson(<String, dynamic>{'themeMode': 'invalid'}).themeMode,
      ThemeMode.light,
    );
    expect(dark.copyWith().themeMode, ThemeMode.dark);
  });
}
