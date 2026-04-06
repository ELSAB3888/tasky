import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/features/home/home_controller.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/features/tasks/high_priority_screen.dart';
import '../../../core/widgets/custom_check_box.dart';
import '../../../core/widgets/custom_svg_picture.dart';

class HighPriorityTasksWidget extends StatelessWidget {
  const HighPriorityTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder:
          (BuildContext context, HomeController controller, Widget? child) {
            List<TaskModel> tasksList = controller.tasks;
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16, left: 16),
                          child: Text(
                            'High Priority Tasks',
                            style: TextStyle(
                              color: Color(0xFF15B86C),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              tasksList.reversed
                                      .where((e) => e.isHighPriority)
                                      .length >
                                  4
                              ? 4
                              : tasksList.reversed
                                    .where((e) => e.isHighPriority)
                                    .length,
                          itemBuilder: (BuildContext context, int index) {
                            final task = tasksList.reversed
                                .where((e) => e.isHighPriority)
                                .toList()[index];
                            return Row(
                              children: [
                                CustomCheckBox(
                                  value: task.isDone ?? false,
                                  onChanged: (bool? value) {
                                    final index = tasksList.indexWhere(
                                      (e) => e.id == task.id,
                                    );
                                    controller.doneTask(value, index);
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    task.taskName,
                                    style: task.isDone ?? false
                                        ? Theme.of(context).textTheme.titleLarge
                                        : Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return HighPriorityScreen();
                          },
                        ),
                      );
                      controller.lodeTasks();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFFD1DAD6)),
                        ),
                        child: CustomSvgPicture(
                          path: 'images/arrow_up_right.svg',
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
    );
  }
}
