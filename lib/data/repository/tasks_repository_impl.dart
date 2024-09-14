import 'package:estesis_tech/data/source/locale/hive_source.dart';
import 'package:estesis_tech/data/source/remote/rest_source.dart';
import 'package:estesis_tech/domain/model/task/task.dart';
import 'package:estesis_tech/domain/repository/tasks_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

@LazySingleton(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  final RestSource restSource;
  final HiveSource hiveSource;

  TaskRepositoryImpl(this.restSource, this.hiveSource);

  @override
  Future<List<Task>> getTasks({int limit = 50, int offset = 0}) async {
    bool isConnect =
        await InternetConnectionChecker.createInstance().hasConnection;
    if (isConnect) {
      final tasks = await restSource.getTasks(limit: limit, offset: offset);
      await hiveSource.setTasks(tasks);
      return tasks;
    } else {
      final tasks = hiveSource.getTasks();
      return tasks;
    }
  }

  @override
  Future<Task> createTask(
          {required String tagSid,
          required String title,
          required String text,
          required String finishAt,
          required int priority}) =>
      restSource.createTask(
        tagSid: tagSid,
        title: title,
        text: text,
        finishAt: finishAt,
        priority: priority,
      );

  @override
  Future<Task> updateTask(Task task) => restSource.updateTask(task);

  @override
  Future<void> removeTask(String taskSid) => restSource.removeTask(
        taskSid: taskSid,
      );
}
