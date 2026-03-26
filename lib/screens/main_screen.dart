import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/screens/completed_tasks_screen.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/screens/profile_screen.dart';
import 'package:todo/screens/tasks_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    HomeScreen(),
    TasksScreen(),
    CompletedTasksScreen(),
    ProfileScreen(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int? index) {
          setState(() {
            _currentIndex = index ?? 0;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'images/home1.svg',
              colorFilter: ColorFilter.mode(
                _currentIndex == 0 ? Color(0xFF15B86C) : Color(0xFFC6C6C6),
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'images/todo.svg',
              colorFilter: ColorFilter.mode(
                _currentIndex == 1 ? Color(0xFF15B86C) : Color(0xFFC6C6C6),
                BlendMode.srcIn,
              ),
            ),
            label: 'To Do',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'images/completed.svg',
              colorFilter: ColorFilter.mode(
                _currentIndex == 2 ? Color(0xFF15B86C) : Color(0xFFC6C6C6),
                BlendMode.srcIn,
              ),
            ),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'images/profile.svg',
              colorFilter: ColorFilter.mode(
                _currentIndex == 3 ? Color(0xFF15B86C) : Color(0xFFC6C6C6),
                BlendMode.srcIn,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: SafeArea(child: _screens[_currentIndex]),
    );
  }
}
