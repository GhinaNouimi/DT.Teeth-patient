class NetworkErrorMessages {
  const NetworkErrorMessages._();

  static bool _isArabic(String languageCode) {
    return languageCode.toLowerCase().startsWith('ar');
  }

  static String noInternet(String languageCode) {
    return _isArabic(languageCode)
        ? 'لا يوجد اتصال بالإنترنت. يرجى المحاولة لاحقًا.'
        : 'No internet connection. Please try again later.';
  }

  static String offlineReadOnly(String languageCode) {
    return _isArabic(languageCode)
        ? 'أنت غير متصل بالإنترنت. يمكنك استعراض آخر بيانات محفوظة فقط.'
        : 'You are offline. You can only view the last saved data.';
  }

  static String offlineActionNotAllowed(String languageCode) {
    return _isArabic(languageCode)
        ? 'لا يمكن تنفيذ هذه العملية بدون اتصال بالإنترنت.'
        : 'This action cannot be completed without an internet connection.';
  }

  static String noCachedData(String languageCode) {
    return _isArabic(languageCode)
        ? 'لا توجد بيانات محفوظة لعرضها بدون إنترنت.'
        : 'No saved data is available to show offline.';
  }
}