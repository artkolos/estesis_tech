part of 'tasks_bloc.dart';

@freezed
class TasksState with _$TasksState {
  const factory TasksState.initial() = _Initial;

  const factory TasksState.loading() = _Loading;

  const factory TasksState.success({
    @Default([]) List<Task> activeTasks,
    @Default([]) List<Task> doneTasks,
  }) = _Success;
}
