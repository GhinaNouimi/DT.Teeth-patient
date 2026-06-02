import 'package:dio/dio.dart';

class ApiErrorHandler {
  const ApiErrorHandler._();

  static String handle(Object error) {
    if (error is DioException) {
      return _handleDioException(error);
    }

    return 'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً.';
  }

  static String _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionError:
        return 'تعذر الاتصال بالخادم. تأكد من اتصال الإنترنت وحاول مجدداً.';

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'استغرق الاتصال وقتاً أطول من المتوقع. يرجى المحاولة مرة أخرى.';

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.cancel:
        return 'تم إلغاء العملية.';

      default:
        return 'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً.';
    }
  }

  static String _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    if (statusCode == 400) {
      return _extractMessage(data) ?? 'الطلب غير صحيح. يرجى التحقق من البيانات.';
    }

    if (statusCode == 401) {
      return 'انتهت الجلسة. يرجى تسجيل الدخول مجدداً.';
    }

    if (statusCode == 403) {
      return 'لا تملك صلاحية لتنفيذ هذه العملية.';
    }

    if (statusCode == 404) {
      return 'العنصر المطلوب غير موجود.';
    }

    if (statusCode == 422) {
      return _handleValidationErrors(data);
    }

    if (statusCode == 429) {
      return _extractMessage(data) ??
          'تم إرسال عدد كبير من الطلبات. يرجى المحاولة بعد قليل.';
    }

    if (statusCode != null && statusCode >= 500) {
      return 'حدث خطأ في الخادم. يرجى المحاولة لاحقاً.';
    }

    return _extractMessage(data) ?? 'تعذر إكمال العملية. يرجى المحاولة مرة أخرى.';
  }

  static String _handleValidationErrors(dynamic data) {
    if (data is Map<String, dynamic>) {
      final errors = data['errors'];

      if (errors is Map<String, dynamic> && errors.isNotEmpty) {
        final firstField = errors.keys.first;
        final firstError = errors.values.first;

        if (firstError is List && firstError.isNotEmpty) {
          return _translateValidationError(
            field: firstField,
            message: firstError.first.toString(),
          );
        }
      }

      return _extractMessage(data) ?? 'يرجى التأكد من صحة البيانات المدخلة.';
    }

    return 'يرجى التأكد من صحة البيانات المدخلة.';
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];

      if (message is String && message.trim().isNotEmpty) {
        return _translateCommonServerMessage(message);
      }
    }

    return null;
  }

  static String _translateValidationError({
    required String field,
    required String message,
  }) {
    final lowerMessage = message.toLowerCase();

    if (field == 'email' && lowerMessage.contains('already')) {
      return 'هذا البريد الإلكتروني مستخدم مسبقاً.';
    }

    if (field == 'phone' && lowerMessage.contains('already')) {
      return 'رقم الهاتف مستخدم مسبقاً.';
    }

    if (field == 'password') {
      return 'كلمة المرور غير مطابقة للشروط المطلوبة.';
    }

    if (field == 'password_confirmation') {
      return 'تأكيد كلمة المرور غير مطابق.';
    }

    if (field == 'date_of_birth') {
      return 'يرجى إدخال تاريخ ميلاد صحيح.';
    }

    if (field == 'name') {
      return 'يرجى إدخال الاسم بشكل صحيح.';
    }

    if (field == 'address') {
      return 'يرجى إدخال العنوان.';
    }

    if (field.contains('emergency_contact_phone')) {
      return 'يرجى إدخال رقم هاتف الطوارئ بشكل صحيح.';
    }

    return 'يرجى التأكد من صحة البيانات المدخلة.';
  }

  static String _translateCommonServerMessage(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('invalid credentials')) {
      return 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
    }

    if (lowerMessage.contains('unauthenticated')) {
      return 'انتهت الجلسة. يرجى تسجيل الدخول مجدداً.';
    }

    if (lowerMessage.contains('not found')) {
      return 'العنصر المطلوب غير موجود.';
    }

    if (lowerMessage.contains('patient registered successfully')) {
      return 'تم إنشاء الحساب بنجاح.';
    }

    if (lowerMessage.contains('invalid or expired verification code')) {
      return 'رمز التحقق غير صحيح أو منتهي الصلاحية.';
    }

    if (lowerMessage.contains('maximum number of attempts')) {
      return 'تم تجاوز عدد المحاولات المسموح. يرجى المحاولة غداً.';
    }

    if (lowerMessage.contains('verification code is valid')) {
      return 'تم التحقق من الرمز بنجاح.';
    }

    if (lowerMessage.contains('password reset successfully')) {
      return 'تمت إعادة تعيين كلمة المرور بنجاح.';
    }

    if (lowerMessage.contains('code sent') ||
        lowerMessage.contains('verification code sent')) {
      return 'تم إرسال رمز التحقق إلى بريدك الإلكتروني.';
    }

    return message;
  }
}