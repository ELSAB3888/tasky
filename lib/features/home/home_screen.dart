import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo/features/home/home_controller.dart';
import 'package:todo/features/add_task/add_task_screen.dart';
import 'package:todo/features/home/components/high_priority_tasks_widget.dart';
import 'package:todo/features/home/components/sliver_list_widget.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/widgets/custom_svg_picture.dart';
import 'components/achieved_tasks_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (context) => HomeController()..init(),
      child: Consumer<HomeController>(
        builder: (BuildContext context, HomeController value, Widget? child) {
          final controller = context.read<HomeController>();
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: value.userImagePath == null
                                  ? AssetImage('images/i7.jpeg')
                                  : FileImage(File(value.userImagePath!)),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Good Evening ,${value.username}",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Text(
                                  "One task at a time.One step closer.",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () => ThemeController.toggleTheme(),
                              child: Container(
                                height: 34,
                                width: 34,
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(
                                  // تبديل الأيقونة بناءً على المود
                                  ThemeController.isDark()
                                      ? 'images/sun.svg'
                                      : 'images/Icon.svg',
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.secondary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Yuhuu ,Your work Is ',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Row(
                          children: [
                            Text(
                              'almost done ! ',
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            SizedBox(width: 8),
                            CustomSvgPicture.withoutColor(
                              path: 'images/hand.svg',
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        AchievedTasksWidget(
                          totalTask: value.totalTask,
                          totalDoneTasks: value.totalDoneTasks,
                          percent: value.percent,
                        ),
                        SizedBox(height: 8),
                        HighPriorityTasksWidget(
                          tasks: value.tasks,
                          onTap: (bool? value, int? index) {
                            controller.doneTask(value, index);
                          },
                          refresh: () {
                            controller.lodeTasks();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 16),
                          child: Text(
                            "My Tasks",
                            style: Theme.of(
                              context,
                            ).textTheme.displaySmall!.copyWith(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverTaskListWidget(
                    tasks: value.tasks,
                    onTap: (bool? value, int? index) async {
                      controller.doneTask(value, index);
                    },
                    onDelete: (int? id) {
                      controller.deleteTask(id);
                    },
                    onEdit: () {
                      controller.lodeTasks();
                    },
                  ),
                ],
              ),
            ),
            floatingActionButton: SizedBox(
              height: 44,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  final bool? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return AddTaskScreen();
                      },
                    ),
                  );
                  if (result != null && result) {
                    controller.lodeTasks();
                  }
                },

                label: Text('Add New Task'),
                icon: Icon(Icons.add),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
