import 'package:estesis_tech/domain/model/tag/tag.dart';
import 'package:estesis_tech/domain/model/task/task.dart';
import 'package:estesis_tech/domain/model/user/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@preResolve
@singleton
class HiveSource {
  static const String _userKey = 'user';

  static const String _taskKey = 'task';

  late final Box<User> _userBox;

  late final Box<Task> _taskBox;

  @factoryMethod
  static Future<HiveSource> create() async {
    final instance = HiveSource();
    await instance._init();
    return instance;
  }

  Future<void> _init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TagAdapter());
    _userBox = await Hive.openBox(_userKey);
    _taskBox = await Hive.openBox(_taskKey);
  }

  Future<void> setUser(User user) => _userBox.put(_userKey, user);

  Future<void> setTasks(List<Task> tasks) async {
    for (var item in tasks) {
      await _taskBox.put(item.sid, item);
    }
  }

  List<Task> getTasks() => _taskBox.values.toList();

  Future<void> clear() async {
    await _userBox.clear();
  }

  User? getUser() => _userBox.get(_userKey);
}
