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

  static const String _tagKey = 'tag';

  late final Box<User> _userBox;

  late final Box<Task> _taskBox;

  late final Box<Tag> _tagBox;

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
    _tagBox = await Hive.openBox(_tagKey);
  }

  Future<void> setUser(User user) => _userBox.put(_userKey, user);

  Future<void> setTasks(List<Task> tasks) async {
    for (var item in tasks) {
      await _taskBox.put(item.sid, item);
    }
  }

  Future<void> setTags(List<Tag> tags) async {
    for (var item in tags) {
      await _tagBox.put(item.sid, item);
    }
  }

  List<Task> getTasks() => _taskBox.values.toList();

  List<Tag> getTags() => _tagBox.values.toList();

  Future<void> clear() async {
    await _userBox.clear();
  }

  User? getUser() => _userBox.get(_userKey);
}
