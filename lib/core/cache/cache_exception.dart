class CacheException implements Exception {
  final String message;

  const CacheException([
    this.message = 'No cached data found.',
  ]);

  @override
  String toString() => message;
}