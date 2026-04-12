import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/services/preferences_manager.dart';
import 'package:todo/features/navigation/main_screen.dart';
import 'package:todo/features/tasks/controller/tasks_controller.dart';
import 'package:todo/features/welcome/welcome_screen.dart';
import 'core/constants/storage_key.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'core/theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesManager().init();
  ThemeController().init();
  String? username = PreferencesManager().getString(StorageKey.username);
  runApp(MyApp(username: username));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.username});

  final String? username;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeNotifier,
      builder: (context, ThemeMode themeMode, Widget? child) {
        return ChangeNotifierProvider<TasksController>(
          create: (_) => TasksController()..init(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Tasky',
            theme: LightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            home: username == null ? WelcomeScreen() : MainScreen(),
          ),
        );
      },
    );
  }
}
