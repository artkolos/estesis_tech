import 'package:estesis_tech/domain/model/user/user.dart';

abstract class AuthRepository {
  Future<User> singUp(
    String name,
    String email,
    String password,
  );

  Future<void> signIn(
    String email,
    String password,
  );

  Future<void> logout();
}
