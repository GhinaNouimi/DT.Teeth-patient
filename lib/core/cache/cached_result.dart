class CachedResult<T> {
  final T data;
  final bool isFromCache;

  const CachedResult({
    required this.data,
    required this.isFromCache,
  });

  const CachedResult.remote(T data)
      : data = data,
        isFromCache = false;

  const CachedResult.cache(T data)
      : data = data,
        isFromCache = true;
}