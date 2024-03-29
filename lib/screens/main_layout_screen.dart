import 'package:flutter/material.dart';
import 'package:mobile_project/screens/forum_screen.dart';
import 'package:mobile_project/screens/home_screen.dart';
import 'package:mobile_project/screens/planner_screen.dart';
import 'package:mobile_project/screens/setting_screen.dart';
import 'package:mobile_project/widgets/nav_bar.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 1;
  final List<Widget> _screens = const [
    HomeScreen(),
    PlannerScreen(),
    ForumScreen(),
    SettingScreen(),
  ];

  void changeIndex(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: _screens[_currentIndex],
        ),
        bottomNavigationBar: CustomNavigationBar(
          indexPage: _currentIndex,
          onClick: changeIndex,
          button: const [
            Icons.home,
            Icons.edit_square,
            Icons.people,
            Icons.menu,
          ],
        ),
      ),
    );
  }
}
