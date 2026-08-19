import 'package:dt_teeth/core/cache/cache_exception.dart';
import 'package:dt_teeth/core/cache/cache_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

  test('UT-CACHE-01 saves and reads a string', () async {
    await CacheService.saveString(key: 'profile', value: '{"id":1}');
    expect(await CacheService.getString(key: 'profile'), '{"id":1}');
  });

  test('UT-CACHE-02 missing key throws CacheException', () {
    expect(
      CacheService.getString(key: 'missing'),
      throwsA(isA<CacheException>()),
    );
  });

  test('UT-CACHE-03 blank cached value is treated as unavailable', () async {
    await CacheService.saveString(key: 'blank', value: '   ');
    expect(
      CacheService.getString(key: 'blank'),
      throwsA(isA<CacheException>()),
    );
  });

  test('UT-CACHE-04 contains reflects saved and missing keys', () async {
    expect(await CacheService.contains(key: 'doctors'), isFalse);
    await CacheService.saveString(key: 'doctors', value: '[]');
    expect(await CacheService.contains(key: 'doctors'), isTrue);
  });

  test('UT-CACHE-05 remove deletes only the selected key', () async {
    await CacheService.saveString(key: 'a', value: 'A');
    await CacheService.saveString(key: 'b', value: 'B');
    await CacheService.remove(key: 'a');
    expect(await CacheService.contains(key: 'a'), isFalse);
    expect(await CacheService.getString(key: 'b'), 'B');
  });

  test('UT-CACHE-06 clearAll removes every cached key', () async {
    await CacheService.saveString(key: 'a', value: 'A');
    await CacheService.saveString(key: 'b', value: 'B');
    await CacheService.clearAll();
    expect(await CacheService.contains(key: 'a'), isFalse);
    expect(await CacheService.contains(key: 'b'), isFalse);
  });
}
