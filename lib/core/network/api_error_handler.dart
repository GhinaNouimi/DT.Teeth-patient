import 'package:dio/dio.dart';

import 'api_error_mapper.dart';
import 'api_error_messages.dart';

class ApiErrorHandler {
  const ApiErrorHandler._();

  static String handle(
      Object error, {
        required String languageCode,
      }) {
    if (error is DioException) {
      return _handleDioException(error, languageCode);
    }

    return ApiErrorMessages.text(
      languageCode,
      ar: 'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً.',
      en: 'An unexpected error occurred. Please try again later.',
    );
  }

  static String _handleDioException(
      DioException error,
      String languageCode,
      ) {
    switch (error.type) {
      case DioExceptionType.connectionError:
        return ApiErrorMessages.text(
          languageCode,
          ar: 'تعذر الاتصال بالخادم. تأكد من اتصال الإنترنت وحاول مجدداً.',
          en: 'Could not connect to the server. Check your internet connection and try again.',
        );

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiErrorMessages.text(
          languageCode,
          ar: 'استغرق الاتصال وقتاً أطول من المتوقع. يرجى المحاولة مرة أخرى.',
          en: 'The connection took longer than expected. Please try again.',
        );

      case DioExceptionType.transformTimeout:
        return ApiErrorMessages.text(
          languageCode,
          ar: 'استغرق تجهيز البيانات وقتاً أطول من المتوقع.',
          en: 'Processing the response took longer than expected.',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response, languageCode);

      case DioExceptionType.cancel:
        return ApiErrorMessages.text(
          languageCode,
          ar: 'تم إلغاء العملية.',
          en: 'The request was cancelled.',
        );

      case DioExceptionType.badCertificate:
        return ApiErrorMessages.text(
          languageCode,
          ar: 'تعذر التحقق من شهادة الأمان الخاصة بالخادم.',
          en: 'Could not verify the server security certificate.',
        );

      case DioExceptionType.unknown:
        return ApiErrorMessages.text(
          languageCode,
          ar: 'حدث خطأ في الاتصال. يرجى المحاولة لاحقاً.',
          en: 'A connection error occurred. Please try again later.',
        );
    }
  }

  static String _handleBadResponse(
      Response? response,
      String languageCode,
      ) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    if (statusCode == 400) {
      return _extractMessage(data, languageCode) ??
          ApiErrorMessages.text(
            languageCode,
            ar: 'الطلب غير صحيح. يرجى التحقق من البيانات.',
            en: 'The request is invalid. Please check your data.',
          );
    }

    if (statusCode == 401) {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'انتهت الجلسة. يرجى تسجيل الدخول مجدداً.',
        en: 'Your session has expired. Please log in again.',
      );
    }

    if (statusCode == 403) {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'لا تملك صلاحية لتنفيذ هذه العملية.',
        en: 'You do not have permission to perform this action.',
      );
    }

    if (statusCode == 404) {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'العنصر المطلوب غير موجود.',
        en: 'The requested item was not found.',
      );
    }

    if (statusCode == 422) {
      return _handleValidationErrors(data, languageCode);
    }

    if (statusCode == 429) {
      return _extractMessage(data, languageCode) ??
          ApiErrorMessages.text(
            languageCode,
            ar: 'تم إرسال عدد كبير من الطلبات. يرجى المحاولة بعد قليل.',
            en: 'Too many requests. Please try again shortly.',
          );
    }

    if (statusCode != null && statusCode >= 500) {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'حدث خطأ في الخادم. يرجى المحاولة لاحقاً.',
        en: 'A server error occurred. Please try again later.',
      );
    }

    return _extractMessage(data, languageCode) ??
        ApiErrorMessages.text(
          languageCode,
          ar: 'تعذر إكمال العملية. يرجى المحاولة مرة أخرى.',
          en: 'Could not complete the request. Please try again.',
        );
  }

  static String _handleValidationErrors(
      dynamic data,
      String languageCode,
      ) {
    if (data is Map<String, dynamic>) {
      final errors = data['errors'];

      if (errors is Map<String, dynamic> && errors.isNotEmpty) {
        final firstField = errors.keys.first;
        final firstError = errors.values.first;

        if (firstError is List && firstError.isNotEmpty) {
          return ApiErrorMapper.validation(
            field: firstField,
            message: firstError.first.toString(),
            languageCode: languageCode,
          );
        }
      }

      return _extractMessage(data, languageCode) ??
          ApiErrorMessages.text(
            languageCode,
            ar: 'يرجى التأكد من صحة البيانات المدخلة.',
            en: 'Please make sure the entered data is correct.',
          );
    }

    return ApiErrorMessages.text(
      languageCode,
      ar: 'يرجى التأكد من صحة البيانات المدخلة.',
      en: 'Please make sure the entered data is correct.',
    );
  }

  static String? _extractMessage(
      dynamic data,
      String languageCode,
      ) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];

      if (message is String && message.trim().isNotEmpty) {
        return ApiErrorMapper.common(
          message: message,
          languageCode: languageCode,
        );
      }
    }

    return null;
  }
}