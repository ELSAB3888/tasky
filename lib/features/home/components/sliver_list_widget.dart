import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/components/task_item_widget.dart';
import '../../tasks/controller/tasks_controller.dart';

class SliverTaskListWidget extends StatelessWidget {
  const SliverTaskListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksController>(
      builder:
          (BuildContext context, TasksController controller, Widget? child) {
            final tasksList = controller.tasks;
            return tasksList.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        "Add Your Tasks Here",
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall!.copyWith(fontSize: 16),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: EdgeInsets.only(bottom: 50),
                    sliver: SliverList.separated(
                      itemCount: tasksList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 8);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return TaskItemWidget(
                          model: tasksList[index],
                          onChanged: (bool? value) {
                            controller.doneTask(value, index);
                          },
                          onDelete: (int id) {
                            controller.deleteTask(id);
                          },
                          onEdit: () => controller.init(),
                        );
                      },
                    ),
                  );
          },
    );
  }
}
