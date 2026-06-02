import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  Locale _locale = const Locale('ar');

  Locale get locale => _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('lang') ?? 'ar';
    _locale = Locale(langCode);
    notifyListeners();
  }

  Future<void> changeLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    _locale = Locale(langCode);
    await prefs.setString('lang', langCode);
    notifyListeners();
  }
}
