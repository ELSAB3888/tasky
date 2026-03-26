import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo/core/services/preferences_manager.dart';
import 'package:todo/core/widgets/custom_text_from_field.dart'
    show CustomTextFromField;
import 'package:todo/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController taskDescriptionController =
      TextEditingController();

  bool isHighPriority = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: Text('New Task')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Form(
            key: _formKey,
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
                          controller: taskNameController,
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
                          controller: taskDescriptionController,
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
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Switch(
                              value: isHighPriority,
                              onChanged: (bool value) {
                                setState(() {
                                  isHighPriority = value;
                                });
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
                    if (_formKey.currentState?.validate() ?? false) {
                      final taskjson = PreferencesManager().getString('tasks');
                      List<dynamic> taskList = [];
                      if (taskjson != null) {
                        taskList = jsonDecode(taskjson);
                      }
                      TaskModel model = TaskModel(
                        id: taskList.length + 1,
                        taskName: taskNameController.text,
                        taskDescription: taskDescriptionController.text,
                        isHighPriority: isHighPriority,
                      );

                      taskList.add(model.toJson());

                      final taskEncode = jsonEncode(taskList);

                      await PreferencesManager().setString("tasks", taskEncode);

                      Navigator.of(context).pop(true);
                    }
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
  }
}
