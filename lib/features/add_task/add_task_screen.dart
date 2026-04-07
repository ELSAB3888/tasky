import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/widgets/custom_text_from_field.dart'
    show CustomTextFromField;
import 'add_task_controller.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext _) {
    return ChangeNotifierProvider<AddTaskController>(
      create: (_) => AddTaskController(),
      builder: (context, _) {
        final controller = context.read<AddTaskController>();
        return Scaffold(
          appBar: AppBar(centerTitle: false, title: Text('New Task')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFromField(
                              title: 'Task Name',
                              controller: controller.taskNameController,
                              hintText: 'Finish UI design for login screen',
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Please Enter Task Name ";
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            CustomTextFromField(
                              title: 'Task Description',
                              controller: controller.taskDescriptionController,
                              hintText:
                                  'Finish onboarding UI and hand off to devs by Thursday.',
                              maxLines: 5,
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'High Priority ',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Consumer<AddTaskController>(
                                  builder:
                                      (
                                        BuildContext context,
                                        value,
                                        Widget? child,
                                      ) {
                                        return Switch(
                                          value: value.isHighPriority,
                                          onChanged: (bool value) {
                                            controller.toggle(value);
                                          },
                                        );
                                      },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width, 40),
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () async {
                        context.read<AddTaskController>().addTask(context);
                      },
                      icon: Icon(Icons.add),
                      label: Text('Add New Task'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
