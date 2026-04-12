import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/features/tasks/controller/tasks_controller.dart';
import '../../core/components/task_list_widget.dart';

class TodoTasksScreen extends StatelessWidget {
  const TodoTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();
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
            child: Consumer<TasksController>(
              builder: (BuildContext context, value, Widget? child) {
                return TaskListWidget(
                  tasks: controller.todoTasks,
                  onTap: (value, index) async {
                    controller.doneTask(value, index);
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
        ),
      ],
    );
  }
}
