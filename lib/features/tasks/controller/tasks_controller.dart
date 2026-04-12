import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';
import '../../../core/constants/storage_key.dart';
import '../../../core/services/preferences_manager.dart';

class TasksController extends ChangeNotifier {
  List<TaskModel> tasks = [];
  List<TaskModel> completeTasks = [];
  List<TaskModel> todoTasks = [];

  init() {
    _loadTasks();
  }

  void _loadTasks() {
    final finaltask = PreferencesManager().getString(StorageKey.tasks);
    if (finaltask != null) {
      final taskAfterDecode = jsonDecode(finaltask) as List<dynamic>;
      tasks = taskAfterDecode
          .map((element) => TaskModel.fromjson(element))
          .toList();
      todoTasks = tasks.where((element) => element.isDone == false).toList();
      completeTasks = tasks.where((element) => element.isDone == true).toList();
      // calculatePercent();
      notifyListeners();
    }
  }

  void doneTask(bool? value, int? index) async {
    if (index == null) return;
    todoTasks[index].isDone = value ?? false;
    final int newIndex = tasks.indexWhere((e) => e.id == todoTasks[index].id);
    tasks[newIndex] = todoTasks[index];
    await PreferencesManager().setString(StorageKey.tasks, jsonEncode(tasks));
    _loadTasks();
  }

  void doneCompleteTask(bool? value, int? index) async {
    if (index == null) return;
    completeTasks[index].isDone = value ?? false;
    final int newIndex = tasks.indexWhere(
      (e) => e.id == completeTasks[index].id,
    );
    tasks[newIndex] = completeTasks[index];
    await PreferencesManager().setString(StorageKey.tasks, jsonEncode(tasks));
    _loadTasks();
  }

  deleteTask(int? id) async {
    if (id == null) return;
    tasks.removeWhere((e) => e.id == id);
    todoTasks.removeWhere((task) => task.id == id);
    final updatedTask = todoTasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    notifyListeners();
  }
}
