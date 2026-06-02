import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/secure_storage_service.dart';

class AppInterceptor extends Interceptor {
  static const _publicPaths = [
    '/patient/register',
    '/patient/verifyEmail',
    '/patient/sendVerification',
  ];

  static const _sensitiveKeys = {
    'password',
    'password_confirmation',
    'token',
    'access_token',
    'refresh_token',
    'authorization',
  };

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final isPublicPath = _publicPaths.any(
          (path) => options.path.endsWith(path),
    );
    if (!isPublicPath) {
      final token = await SecureStorageService.getToken();
      final tokenType = await SecureStorageService.getTokenType();

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = '${tokenType ?? 'Bearer'} $token';
      }
    }

    if (kDebugMode) {
      debugPrint('➡️ REQUEST');
      debugPrint('URL: ${options.uri}');
      debugPrint('METHOD: ${options.method}');
      debugPrint('HEADERS: ${_hideSensitiveData(options.headers)}');
      debugPrint('DATA: ${_hideSensitiveData(options.data)}');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('✅ RESPONSE');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('URL: ${response.requestOptions.uri}');
      debugPrint('DATA: ${_hideSensitiveData(response.data)}');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('❌ ERROR');
      debugPrint('URL: ${err.requestOptions.uri}');
      debugPrint('STATUS: ${err.response?.statusCode}');
      debugPrint('TYPE: ${err.type}');
      debugPrint('MESSAGE: ${err.message}');
      debugPrint('RESPONSE: ${_hideSensitiveData(err.response?.data)}');
    }

    handler.next(err);
  }

  dynamic _hideSensitiveData(dynamic data) {
    if (data is Map) {
      return data.map((key, value) {
        final normalizedKey = key.toString().toLowerCase();

        if (_sensitiveKeys.contains(normalizedKey)) {
          return MapEntry(key, '***');
        }

        return MapEntry(key, _hideSensitiveData(value));
      });
    }

    if (data is List) {
      return data.map(_hideSensitiveData).toList();
    }

    return data;
  }
}