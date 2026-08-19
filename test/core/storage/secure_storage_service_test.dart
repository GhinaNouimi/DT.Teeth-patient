import 'package:dt_teeth/core/storage/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  test('UT-SEC-01 saves and reads token and token type', () async {
    await SecureStorageService.saveToken(
      token: 'secure-token',
      tokenType: 'Bearer',
    );

    expect(await SecureStorageService.getToken(), 'secure-token');
    expect(await SecureStorageService.getTokenType(), 'Bearer');
  });

  test('UT-SEC-02 clearToken removes authentication data', () async {
    await SecureStorageService.saveToken(
      token: 'secure-token',
      tokenType: 'Bearer',
    );

    await SecureStorageService.clearToken();

    expect(await SecureStorageService.getToken(), isNull);
    expect(await SecureStorageService.getTokenType(), isNull);
  });
}
