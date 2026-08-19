import 'package:dio/dio.dart';
import 'package:dt_teeth/core/cache/cache_exception.dart';
import 'package:dt_teeth/core/network/api_error_handler.dart';
import 'package:dt_teeth/core/network/api_error_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

final requestOptions = RequestOptions(path: '/api/test');

DioException dioError(DioExceptionType type, {int? statusCode, dynamic data}) {
  return DioException(
    requestOptions: requestOptions,
    type: type,
    response: statusCode == null
        ? null
        : Response<dynamic>(
            requestOptions: requestOptions,
            statusCode: statusCode,
            data: data,
          ),
  );
}

void main() {
  group('ApiErrorHandler connection errors', () {
    test('UT-ERR-01 maps connection error in English and Arabic', () {
      final error = dioError(DioExceptionType.connectionError);

      expect(
        ApiErrorHandler.handle(error, languageCode: 'en'),
        'Could not connect to the server. Check your internet connection and try again.',
      );
      expect(
        ApiErrorHandler.handle(error, languageCode: 'ar'),
        'تعذر الاتصال بالخادم. تأكد من اتصال الإنترنت وحاول مجدداً.',
      );
    });

    test(
      'UT-ERR-02 maps connection, send, and receive timeouts consistently',
      () {
        for (final type in <DioExceptionType>[
          DioExceptionType.connectionTimeout,
          DioExceptionType.sendTimeout,
          DioExceptionType.receiveTimeout,
        ]) {
          expect(
            ApiErrorHandler.handle(dioError(type), languageCode: 'en'),
            'The connection took longer than expected. Please try again.',
          );
        }
      },
    );

    test('UT-ERR-03 maps cancellation and bad certificate separately', () {
      expect(
        ApiErrorHandler.handle(
          dioError(DioExceptionType.cancel),
          languageCode: 'en',
        ),
        'The request was cancelled.',
      );
      expect(
        ApiErrorHandler.handle(
          dioError(DioExceptionType.badCertificate),
          languageCode: 'en',
        ),
        'Could not verify the server security certificate.',
      );
    });
  });

  group('ApiErrorHandler HTTP responses', () {
    test('UT-ERR-04 maps 401 to an expired-session message', () {
      final error = dioError(DioExceptionType.badResponse, statusCode: 401);

      expect(
        ApiErrorHandler.handle(error, languageCode: 'en'),
        'Your session has expired. Please log in again.',
      );
    });

    test('UT-ERR-05 maps 403 to a permission message', () {
      final error = dioError(DioExceptionType.badResponse, statusCode: 403);

      expect(
        ApiErrorHandler.handle(error, languageCode: 'ar'),
        'لا تملك صلاحية لتنفيذ هذه العملية.',
      );
    });

    test('UT-ERR-06 maps 404 to a not-found message', () {
      final error = dioError(DioExceptionType.badResponse, statusCode: 404);

      expect(
        ApiErrorHandler.handle(error, languageCode: 'en'),
        'The requested item was not found.',
      );
    });

    test(
      'UT-ERR-07 maps 500 and higher responses to a server-error message',
      () {
        for (final status in <int>[500, 502, 503]) {
          final error = dioError(
            DioExceptionType.badResponse,
            statusCode: status,
          );

          expect(
            ApiErrorHandler.handle(error, languageCode: 'en'),
            'A server error occurred. Please try again later.',
          );
        }
      },
    );

    test('UT-ERR-08 maps 422 email-taken validation error', () {
      final error = dioError(
        DioExceptionType.badResponse,
        statusCode: 422,
        data: <String, dynamic>{
          'errors': <String, dynamic>{
            'email': <String>['The email has already been taken.'],
          },
        },
      );

      expect(
        ApiErrorHandler.handle(error, languageCode: 'en'),
        'This email address is already in use.',
      );
    });

    test('UT-ERR-09 maps 422 password confirmation error', () {
      final error = dioError(
        DioExceptionType.badResponse,
        statusCode: 422,
        data: <String, dynamic>{
          'errors': <String, dynamic>{
            'password_confirmation': <String>['does not match'],
          },
        },
      );

      expect(
        ApiErrorHandler.handle(error, languageCode: 'ar'),
        'تأكيد كلمة المرور غير مطابق.',
      );
    });

    test('UT-ERR-10 uses a safe fallback for malformed 422 data', () {
      final error = dioError(
        DioExceptionType.badResponse,
        statusCode: 422,
        data: <String, dynamic>{'errors': <String, dynamic>{}},
      );

      expect(
        ApiErrorHandler.handle(error, languageCode: 'en'),
        'Please make sure the entered data is correct.',
      );
    });

    test('UT-ERR-11 maps 429 without a message to retry-later text', () {
      final error = dioError(DioExceptionType.badResponse, statusCode: 429);

      expect(
        ApiErrorHandler.handle(error, languageCode: 'en'),
        'Too many requests. Please try again shortly.',
      );
    });

    test('UT-ERR-12 maps backend invalid-credentials message from 400', () {
      final error = dioError(
        DioExceptionType.badResponse,
        statusCode: 400,
        data: <String, dynamic>{'message': 'Invalid credentials'},
      );

      expect(
        ApiErrorHandler.handle(error, languageCode: 'en'),
        'Email or password is incorrect.',
      );
    });
  });

  group('ApiErrorHandler non-HTTP errors', () {
    test('UT-ERR-13 preserves a CacheException message', () {
      expect(
        ApiErrorHandler.handle(
          const CacheException('No cached profile.'),
          languageCode: 'en',
        ),
        'No cached profile.',
      );
    });

    test('UT-ERR-14 hides unexpected technical exception details', () {
      expect(
        ApiErrorHandler.handle(
          Exception('database password leaked'),
          languageCode: 'en',
        ),
        'An unexpected error occurred. Please try again later.',
      );
    });
  });

  group('ApiErrorMapper business messages', () {
    test('UT-ERR-15 maps appointment cancellation within 24 hours', () {
      expect(
        ApiErrorMapper.common(
          message: 'لا يمكن إلغاء الموعد قبل أقل من 24 ساعة',
          languageCode: 'en',
        ),
        'The appointment cannot be cancelled less than 24 hours before its scheduled time.',
      );
    });

    test('UT-ERR-16 maps duplicate offer application', () {
      expect(
        ApiErrorMapper.common(
          message: 'تم استخدام عرض على هذا العلاج مسبقاً',
          languageCode: 'en',
        ),
        'An offer has already been applied to this treatment, so another offer cannot be applied.',
      );
    });

    test('UT-ERR-17 maps maximum pending appointment rule', () {
      expect(
        ApiErrorMapper.common(
          message: 'لديك 3 مواعيد قيد الانتظار',
          languageCode: 'ar',
        ),
        'لديك بالفعل 3 مواعيد قيد الانتظار. يرجى انتظار الرد عليها قبل حجز موعد جديد.',
      );
    });
  });
}
