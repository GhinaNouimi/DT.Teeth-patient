import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/secure_storage_service.dart';

class AppInterceptor extends Interceptor {
  static const _publicPaths = [
    '/patient/register',
    '/patient/verifyEmail',
    '/patient/sendVerification',
  ];

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final isPublicPath = _publicPaths.contains(options.path);

    if (!isPublicPath) {
      final token = await SecureStorageService.getToken();
      final tokenType = await SecureStorageService.getTokenType();

      debugPrint('SAVED TOKEN: $token');
      debugPrint('SAVED TOKEN TYPE: $tokenType');

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = '${tokenType ?? 'Bearer'} $token';
      }
    }

    if (kDebugMode) {
      debugPrint('➡️ REQUEST');
      debugPrint('URL: ${options.baseUrl}${options.path}');
      debugPrint('METHOD: ${options.method}');
      debugPrint('HEADERS: ${options.headers}');
      debugPrint('DATA: ${options.data}');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('✅ RESPONSE');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('URL: ${response.requestOptions.uri}');
      debugPrint('DATA: ${response.data}');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('❌ ERROR');
      debugPrint('URL: ${err.requestOptions.uri}');
      debugPrint('STATUS: ${err.response?.statusCode}');
      debugPrint('MESSAGE: ${err.message}');
      debugPrint('RESPONSE: ${err.response?.data}');
    }

    handler.next(err);
  }
}