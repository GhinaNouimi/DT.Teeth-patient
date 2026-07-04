import 'package:shared_preferences/shared_preferences.dart';

import 'cache_exception.dart';

class CacheService {
  CacheService._();

  static Future<void> saveString({
    required String key,
    required String value,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String> getString({
    required String key,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);

    if (value == null || value.trim().isEmpty) {
      throw const CacheException();
    }

    return value;
  }

  static Future<void> remove({
    required String key,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> contains({
    required String key,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}