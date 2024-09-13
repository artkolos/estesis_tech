import 'package:estesis_tech/domain/model/task/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks({
    int limit = 50,
    int offset = 0,
  });

  Future<Task> createTask({
    required String tagSid,
    required String title,
    required String text,
    required String finishAt,
    required int priority,
  });

  Future<Task> updateTask(Task task);

  Future<void> removeTask(String taskSid);
}
