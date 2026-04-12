import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/features/tasks/controller/tasks_controller.dart';
import 'package:todo/core/components/task_list_widget.dart';

class HighPriorityScreen extends StatelessWidget {
  const HighPriorityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();
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
        child: Consumer<TasksController>(
          builder: (BuildContext context, value, Widget? child) {
            return TaskListWidget(
              tasks: value.highPriorityTasks,
              onTap: (value, index) async {
                controller.doneHighPriorityTasksTask(value, index);
              },
              emptyMessage: "No Tasks Yet",
              onDelete: (int? id) {
                controller.deleteTask(id);
              },
              onEdit: () {
                controller.init();
              },
            );
          },
        ),
      ),
    );
  }
}
