import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';
import '../../../core/constants/storage_key.dart';
import '../../../core/services/preferences_manager.dart';

class TasksController extends ChangeNotifier {
  List<TaskModel> tasks = [];
  List<TaskModel> completeTasks = [];
  List<TaskModel> todoTasks = [];
  List<TaskModel> highPriorityTasks = [];
  int totalTask = 0;
  int totalDoneTasks = 0;
  double percent = 0;

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

      _LoadData();

      _calculatePercent();
      notifyListeners();
    }
  }

  void _LoadData() {
    todoTasks = tasks.where((element) => element.isDone == false).toList();
    completeTasks = tasks.where((element) => element.isDone == true).toList();
    highPriorityTasks = tasks
        .where((element) => element.isHighPriority)
        .toList();
    highPriorityTasks = highPriorityTasks.reversed.toList();
  }

  void doneTask(bool? value, int id) async {
    final index = tasks.indexWhere((e) => e.id == id);
    tasks[index].isDone = value ?? false;
    _LoadData();
    _calculatePercent();
    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    notifyListeners();
  }

  deleteTask(int? id) async {
    if (id == null) return;
    tasks.removeWhere((e) => e.id == id);
    _LoadData();
    _calculatePercent();
    final updatedTask = todoTasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    notifyListeners();
  }

  _calculatePercent() {
    totalTask = tasks.length;
    totalDoneTasks = tasks.where((e) => e.isDone ?? false).length;
    percent = totalTask == 0 ? 0 : totalDoneTasks / totalTask;
    notifyListeners();
  }
}
