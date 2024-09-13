part of 'tasks_bloc.dart';

@freezed
class TasksEvent with _$TasksEvent {
  const factory TasksEvent.getTasks({
    @Default(true) bool isShowAllTasks,
  }) = _GetTasks;

  const factory TasksEvent.filterTasksOnDate({required DateTime date}) =
      _FilterTasksOnDate;

  const factory TasksEvent.filterTasksOnTagAndName({
    required String tagName,
    @Default('') String search,
    @Default(false) bool isShowAll,
  }) = _FilterTasksOnTag;

  const factory TasksEvent.createTask({
    required String tagSid,
    required String title,
    required String text,
    required String finishAt,
    required int priority,
  }) = _CreateTask;

  const factory TasksEvent.updateTask({
    required Task task,
  }) = _UpdateTask;

  const factory TasksEvent.removeTask({
    required String taskSid,
  }) = _RemoveTask;
}
