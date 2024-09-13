import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String email;

  User(
    this.name,
    this.email,
  );

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];

  @override
  String toString() => 'User{name: $name, email: $email}';
}
