import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/constants/storage_key.dart';
import '../../core/services/preferences_manager.dart';
import '../../models/task_model.dart';

class AddTaskController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController taskDescriptionController =
      TextEditingController();
  bool isHighPriority = true;

  void addTask(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      final taskjson = PreferencesManager().getString(StorageKey.tasks);
      List<dynamic> taskList = [];
      if (taskjson != null) {
        taskList = jsonDecode(taskjson);
      }
      TaskModel model = TaskModel(
        id: taskList.length + 1,
        taskName: taskNameController.text,
        taskDescription: taskDescriptionController.text,
        isHighPriority: isHighPriority,
      );

      taskList.add(model.toJson());

      final taskEncode = jsonEncode(taskList);

      await PreferencesManager().setString(StorageKey.tasks, taskEncode);

      Navigator.of(context).pop(true);
    }
  }

  void toggle(bool value) {
    isHighPriority = value;
    notifyListeners();
  }
}
