import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';
import '../../core/services/preferences_manager.dart';
import '../../core/components/task_list_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<TaskModel> todoTasks = [];

  @override
  void initState() {
    super.initState();

    _lodeTasks();
  }

  void _lodeTasks() async {
    final finaltask = PreferencesManager().getString("tasks");
    if (finaltask != null) {
      final taskAfterDecode = jsonDecode(finaltask) as List<dynamic>;
      setState(() {
        todoTasks = taskAfterDecode
            .map((element) => TaskModel.fromjson(element))
            .where((element) => element.isDone == false)
            .toList();
      });
    }
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
        todoTasks.removeWhere((task) => task.id == id);
      });
      final updatedTask = todoTasks.map((element) => element.toJson()).toList();
      PreferencesManager().setString('tasks', jsonEncode(updatedTask));
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
            'To Do Tasks',
            style: Theme.of(
              context,
            ).textTheme.displaySmall!.copyWith(fontSize: 20),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TaskListWidget(
              tasks: todoTasks,
              onTap: (value, index) async {
                setState(() {
                  todoTasks[index!].isDone = value ?? false;
                });
                final allData = PreferencesManager().getString('tasks');
                if (allData != null) {
                  List<TaskModel> allDataList = (jsonDecode(allData) as List)
                      .map((element) => TaskModel.fromjson(element))
                      .toList();
                  final int newIndex = allDataList.indexWhere(
                    (e) => e.id == todoTasks[index!].id,
                  );
                  allDataList[newIndex] = todoTasks[index!];

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
