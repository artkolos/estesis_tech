import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:estesis_tech/domain/model/task/task.dart';
import 'package:estesis_tech/domain/repository/tasks_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'tasks_bloc.freezed.dart';

part 'tasks_event.dart';

part 'tasks_state.dart';

@injectable
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc(this.taskRepository) : super(const TasksState.initial()) {
    on(_mapOn);
  }

  final TaskRepository taskRepository;

  final List<Task> _activeTasks = List.empty(growable: true);
  final List<Task> _doneTasks = List.empty(growable: true);

  FutureOr<void> _mapOn(TasksEvent mainEvent, Emitter<TasksState> emit) =>
      mainEvent.map(
        getTasks: (event) => _getTasks(event, emit),
        createTask: (event) => _createTask(event, emit),
        updateTask: (event) => _updateTask(event, emit),
        removeTask: (event) => _deleteTask(event, emit),
        filterTasksOnDate: (event) => _filterTaskOnDate(event, emit),
        filterTasksOnTagAndName: (event) =>
            _filterTasksOnTagAndName(event, emit),
      );

  Future<void> _getTasks(_GetTasks event, Emitter<TasksState> emit) async {
    emit(const TasksState.loading());
    final tasks = await taskRepository.getTasks();
    final activeTasks = tasks.where((e) => !e.isDone);
    final doneTasks = tasks.where((e) => e.isDone);
    _activeTasks.clear();
    _doneTasks.clear();
    _activeTasks.addAll([...activeTasks]);
    _doneTasks.addAll([...doneTasks]);
    if (!event.isShowAllTasks) {
      final filteredActiveTasks = _activeTasks.where(
        (e) {
          final date = DateTime.tryParse(e.finishAt ?? '');
          return date?.day == DateTime.now().day &&
              date?.month == DateTime.now().month;
        },
      );
      final filteredDoneTasks = _doneTasks.where(
        (e) {
          final date = DateTime.tryParse(e.finishAt ?? '');
          return date?.day == DateTime.now().day &&
              date?.month == DateTime.now().month;
        },
      );
      emit(
        TasksState.success(
          activeTasks: [...filteredActiveTasks],
          doneTasks: [...filteredDoneTasks],
        ),
      );
      return;
    }
    emit(
      TasksState.success(
        activeTasks: [..._activeTasks],
        doneTasks: [..._doneTasks],
      ),
    );
  }

  Future<void> _filterTaskOnDate(
      _FilterTasksOnDate event, Emitter<TasksState> emit) async {
    final filteredActiveTasks = _activeTasks.where(
      (e) {
        final date = DateTime.tryParse(e.finishAt ?? '');
        return date?.day == event.date.day && date?.month == event.date.month;
      },
    );
    final filteredDoneTasks = _doneTasks.where(
      (e) {
        final date = DateTime.tryParse(e.finishAt ?? '');
        return date?.day == event.date.day && date?.month == event.date.month;
      },
    );
    emit(
      TasksState.success(
        activeTasks: [...filteredActiveTasks],
        doneTasks: [...filteredDoneTasks],
      ),
    );
  }

  Future<void> _createTask(_CreateTask event, Emitter<TasksState> emit) {
    return taskRepository.createTask(
      tagSid: event.tagSid,
      title: event.title,
      text: event.text,
      finishAt: event.finishAt,
      priority: event.priority,
    );
  }

  Future<void> _updateTask(_UpdateTask event, Emitter<TasksState> emit) async {
    await taskRepository.updateTask(event.task);
    add(const TasksEvent.getTasks(isShowAllTasks: false));
  }

  Future<void> _deleteTask(_RemoveTask event, Emitter<TasksState> emit) async {
    await taskRepository.removeTask(event.taskSid);
    add(const TasksEvent.getTasks(isShowAllTasks: false));
  }

  void _filterTasksOnTagAndName(
      _FilterTasksOnTag event, Emitter<TasksState> emit) {
    if (event.isShowAll && event.search.isEmpty) {
      emit(TasksState.success(
          activeTasks: [..._activeTasks], doneTasks: [..._doneTasks]));
      return;
    }
    if (event.isShowAll && event.search.isNotEmpty) {
      final filteredActiveTasks =
          _activeTasks.where((e) => e.title.toLowerCase().contains(event.search.toLowerCase()));
      final filteredDoneTasks =
          _doneTasks.where((e) => e.title.toLowerCase().contains(event.search.toLowerCase()));
      emit(
        TasksState.success(
          activeTasks: [...filteredActiveTasks],
          doneTasks: [...filteredDoneTasks],
        ),
      );
      return;
    }
    if (event.search.isEmpty) {
      final filteredActiveTasks =
          _activeTasks.where((e) => event.tagName == e.tag.name);
      final filteredDoneTasks =
          _doneTasks.where((e) => event.tagName == e.tag.name);
      emit(
        TasksState.success(
          activeTasks: [...filteredActiveTasks],
          doneTasks: [...filteredDoneTasks],
        ),
      );
    } else {
      final filteredActiveTasks = _activeTasks.where((e) =>
          (event.tagName == e.tag.name && e.title.contains(event.search)));
      final filteredDoneTasks = _doneTasks.where((e) =>
          (event.tagName == e.tag.name && e.title.contains(event.search)));
      emit(
        TasksState.success(
          activeTasks: [...filteredActiveTasks],
          doneTasks: [...filteredDoneTasks],
        ),
      );
    }
  }
}
