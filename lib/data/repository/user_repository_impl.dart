import 'package:estesis_tech/data/source/locale/hive_source.dart';
import 'package:estesis_tech/data/source/remote/rest_source.dart';
import 'package:estesis_tech/domain/model/user/user.dart';
import 'package:estesis_tech/domain/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this.hiveSource, this.restSource);

  final HiveSource hiveSource;
  final RestSource restSource;

  @override
  Future<User> getUser(String name, String email) => restSource.getUserMe();

  @override
  User? getUserFromStorage() => hiveSource.getUser();

  @override
  Future<void> saveUser(User user) => hiveSource.setUser(user);
}
