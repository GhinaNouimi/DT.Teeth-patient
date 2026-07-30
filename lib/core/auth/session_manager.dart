import 'dart:async';

import 'package:flutter/foundation.dart';

import '../storage/secure_storage_service.dart';

typedef SessionExpiredCallback = FutureOr<void> Function();

class SessionManager {
  SessionManager._();

  static SessionExpiredCallback? onSessionExpired;

  static bool _isSessionExpired = false;
  static bool _isHandlingUnauthorized = false;

  static bool get isSessionExpired {
    return _isSessionExpired;
  }

  static Future<void> handleUnauthorized() async {
    // منع تنفيذ العملية عدة مرات عند وصول أكثر من طلب 401.
    if (_isHandlingUnauthorized || _isSessionExpired) {
      return;
    }

    _isHandlingUnauthorized = true;
    _isSessionExpired = true;

    try {
      if (kDebugMode) {
        debugPrint(
          '🔐 Session expired: clearing local authentication data.',
        );
      }

      await SecureStorageService.clearToken();

      await onSessionExpired?.call();
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          '❌ Failed to handle expired session: $error',
        );
        debugPrintStack(
          stackTrace: stackTrace,
        );
      }
    } finally {
      _isHandlingUnauthorized = false;
    }
  }

  /// يجب استدعاؤها بعد نجاح تسجيل الدخول وحفظ التوكن الجديد.
  static void markSessionAsActive() {
    _isSessionExpired = false;
    _isHandlingUnauthorized = false;

    if (kDebugMode) {
      debugPrint('✅ Authentication session is active.');
    }
  }
}