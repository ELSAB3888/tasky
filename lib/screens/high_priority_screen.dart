import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';
import 'dart:convert';
import 'package:todo/widgets/task_list_widget.dart';
import '../core/services/preferences_manager.dart';

class HighPriorityScreen extends StatefulWidget {
  const HighPriorityScreen({super.key});

  @override
  State<HighPriorityScreen> createState() => _HighPriorityScreenState();
}

class _HighPriorityScreenState extends State<HighPriorityScreen> {
  List<TaskModel> highPriorityTasks = [];

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
        highPriorityTasks.removeWhere((task) => task.id == id);
      });
      final updatedTask = highPriorityTasks
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
        highPriorityTasks = taskAfterDecode
            .map((element) => TaskModel.fromjson(element))
            .where((element) => element.isHighPriority)
            .toList();
        highPriorityTasks = highPriorityTasks.reversed.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFFCFCFC)),
        title: Text(
          "High Priority Tasks",
          style: Theme.of(
            context,
          ).textTheme.displaySmall!.copyWith(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TaskListWidget(
          tasks: highPriorityTasks,
          onTap: (value, index) async {
            setState(() {
              highPriorityTasks[index!].isDone = value ?? false;
            });
            final allData = PreferencesManager().getString('tasks');
            if (allData != null) {
              List<TaskModel> allDataList = (jsonDecode(allData) as List)
                  .map((element) => TaskModel.fromjson(element))
                  .toList();
              final int newIndex = allDataList.indexWhere(
                (e) => e.id == highPriorityTasks[index!].id,
              );
              allDataList[newIndex] = highPriorityTasks[index!];

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
    );
  }
}
