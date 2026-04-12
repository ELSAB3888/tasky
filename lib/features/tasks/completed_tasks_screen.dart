import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/features/tasks/controller/tasks_controller.dart';
import '../../core/components/task_list_widget.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();
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
            child: Consumer<TasksController>(
              builder: (BuildContext context, value, Widget? child) {
                return TaskListWidget(
                  tasks: value.completeTasks,
                  onTap: (value, index) async {
                    controller.doneCompleteTask(value, index);
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
