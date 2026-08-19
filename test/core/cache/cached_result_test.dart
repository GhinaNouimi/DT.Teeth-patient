import 'package:dt_teeth/core/cache/cached_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CachedResult', () {
    test('UT-CORE-01 remote marks data as coming from remote', () {
      const data = <int>[1, 2, 3];

      const result = CachedResult<List<int>>.remote(data);

      expect(result.data, same(data));
      expect(result.isFromCache, isFalse);
    });

    test('UT-CORE-02 cache marks data as coming from cache', () {
      const data = <String>['cached'];

      const result = CachedResult<List<String>>.cache(data);

      expect(result.data, same(data));
      expect(result.isFromCache, isTrue);
    });

    test('default constructor preserves data and source flag', () {
      const result = CachedResult<String>(data: 'value', isFromCache: true);

      expect(result.data, 'value');
      expect(result.isFromCache, isTrue);
    });
  });
}
