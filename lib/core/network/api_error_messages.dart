class ApiErrorMessages {
  const ApiErrorMessages._();

  static String text(
      String languageCode, {
        required String ar,
        required String en,
      }) {
    return languageCode.toLowerCase().startsWith('ar') ? ar : en;
  }
}