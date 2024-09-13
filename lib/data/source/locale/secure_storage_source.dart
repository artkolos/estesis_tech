import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@singleton
class SecureStorageSource {
  static const String _accessTokenKey = 'accessTokenKey';
  static const String _refreshTokenKey = 'refreshTokenKey';

  final FlutterSecureStorage _secureStorage;

  SecureStorageSource._(this._secureStorage);

  @factoryMethod
  static SecureStorageSource create() {
    const storage = FlutterSecureStorage();
    return SecureStorageSource._(storage);
  }

  Future<void> setAccessToken(String token) => _secureStorage.write(
        key: _accessTokenKey,
        value: token,
      );

  Future<void> setRefreshToken(String token) => _secureStorage.write(
        key: _refreshTokenKey,
        value: token,
      );

  Future<String?> getAccessToken() => _secureStorage.read(key: _accessTokenKey);

  Future<String?> getRefreshToken() => _secureStorage.read(
        key: _refreshTokenKey,
      );

  Future<void> clear() => _secureStorage.deleteAll();
}
