import 'package:estesis_tech/domain/model/user/user.dart';

abstract class UserRepository {
  Future<void> saveUser(User user);

  User? getUserFromStorage();

  Future<User> getUser(String name, String email);
}
