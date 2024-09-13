import 'package:estesis_tech/data/source/locale/hive_source.dart';
import 'package:estesis_tech/data/source/locale/secure_storage_source.dart';
import 'package:estesis_tech/data/source/remote/rest_source.dart';
import 'package:estesis_tech/domain/model/user/user.dart';
import 'package:estesis_tech/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final RestSource restSource;
  final SecureStorageSource secureStorageSource;
  final HiveSource hiveSource;

  AuthRepositoryImpl(
    this.restSource,
    this.secureStorageSource,
    this.hiveSource,
  );

  @override
  Future<User> singUp(
    String name,
    String email,
    String password,
  ) =>
      restSource.signUp(name, email, password);

  @override
  Future<void> signIn(String email, String password) async {
    final tokens = await restSource.signIn(email, password);
    secureStorageSource.setAccessToken(tokens['access_token']);
    secureStorageSource.setRefreshToken(tokens['refresh_token']);
  }

  @override
  Future<void> logout() async {
    await hiveSource.clear();
    await secureStorageSource.clear();
  }
}
