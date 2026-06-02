import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService._();

  static const _storage = FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _tokenTypeKey = 'token_type';

  static Future<void> saveToken({
    required String token,
    required String tokenType,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _tokenTypeKey, value: tokenType);
  }

  static Future<String?> getToken() {
    return _storage.read(key: _tokenKey);
  }

  static Future<String?> getTokenType() {
    return _storage.read(key: _tokenTypeKey);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _tokenTypeKey);
  }
}
