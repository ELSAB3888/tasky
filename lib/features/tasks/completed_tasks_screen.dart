import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:todo/core/services/preferences_manager.dart';
import 'package:todo/models/task_model.dart';
import '../../core/components/task_list_widget.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  List<TaskModel> completeTasks = [];

  @override
  void initState() {
    super.initState();

    _lodeTasks();
  }

  _deleteTask(int? id) async {
    List<TaskModel> tasks = [];
    if (id == null) return;
    final finaltask = PreferencesManager().getString('tasks');
    if (finaltask != null) {
      final taskAfterDecode = jsonDecode(finaltask) as List<dynamic>;
      tasks = taskAfterDecode
          .map((element) => TaskModel.fromjson(element))
          .toList();
      tasks.removeWhere((e) => e.id == id);

      setState(() {
        completeTasks.removeWhere((task) => task.id == id);
      });
      final updatedTask = completeTasks
          .map((element) => element.toJson())
          .toList();
      PreferencesManager().setString('tasks', jsonEncode(updatedTask));
    }
  }

  void _lodeTasks() async {
    final finaltask = PreferencesManager().getString('tasks');

    if (finaltask != null) {
      final taskAfterDecode = jsonDecode(finaltask) as List<dynamic>;
      setState(() {
        completeTasks = taskAfterDecode
            .map((element) => TaskModel.fromjson(element))
            .where((element) => element.isDone == true)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            'Completed Tasks',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TaskListWidget(
              tasks: completeTasks,
              onTap: (value, index) async {
                setState(() {
                  completeTasks[index!].isDone = value ?? false;
                });
                final allData = PreferencesManager().getString('tasks');
                if (allData != null) {
                  List<TaskModel> allDataList = (jsonDecode(allData) as List)
                      .map((element) => TaskModel.fromjson(element))
                      .toList();
                  final int newIndex = allDataList.indexWhere(
                    (e) => e.id == completeTasks[index!].id,
                  );
                  allDataList[newIndex] = completeTasks[index!];
                  await PreferencesManager().setString(
                    'tasks',
                    jsonEncode(allDataList),
                  );
                  _lodeTasks();
                }
              },
              emptyMessage: "No Tasks Yet",
              onDelete: (int? id) {
                _deleteTask(id);
              },
              onEdit: () {
                _lodeTasks();
              },
            ),
          ),
        ),
      ],
    );
  }
}
