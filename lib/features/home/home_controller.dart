import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:todo/models/task_model.dart';

import '../../core/constants/storage_key.dart';
import '../../core/services/preferences_manager.dart';

class HomeController with ChangeNotifier {
  List<TaskModel> tasksList = [];
  String? username = "Default";
  String? userImagePath;
  List<TaskModel> tasks = [];
  int totalTask = 0;
  int totalDoneTasks = 0;
  double percent = 0;

  init() {
    lodeUserName();
    lodeTasks();
  }

  void lodeUserName() async {
    username = PreferencesManager().getString(StorageKey.username);
    userImagePath = PreferencesManager().getString(StorageKey.userImage);

    notifyListeners();
  }

  void lodeTasks() async {
    final finaltask = PreferencesManager().getString(StorageKey.tasks);
    if (finaltask != null) {
      final taskAfterDecode = jsonDecode(finaltask) as List<dynamic>;

      tasks = taskAfterDecode
          .map((element) => TaskModel.fromjson(element))
          .toList();
      calculatePercent();
      notifyListeners();
    }
  }

  calculatePercent() {
    totalTask = tasks.length;
    totalDoneTasks = tasks.where((e) => e.isDone ?? false).length;
    percent = totalTask == 0 ? 0 : totalDoneTasks / totalTask;
    notifyListeners();
  }

  doneTask(bool? value, int? index) async {
    tasks[index!].isDone = value ?? false;
    calculatePercent();

    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    notifyListeners();
  }

  deleteTask(int? id) async {
    if (id == null) return;

    tasks.removeWhere((task) => task.id == id);
    calculatePercent();

    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    notifyListeners();
  }
}
