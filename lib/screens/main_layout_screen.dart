import 'package:flutter/material.dart';
import 'package:mobile_project/models/user.dart' as appUser;
import 'package:mobile_project/screens/forum_screen.dart';
import 'package:mobile_project/screens/home_screen.dart';
import 'package:mobile_project/screens/planner_screen.dart';
import 'package:mobile_project/screens/setting_screen.dart';
import 'package:mobile_project/widgets/nav_bar.dart';

class MainLayoutScreen extends StatefulWidget {
  final appUser.User user;

  const MainLayoutScreen({super.key, required this.user});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const PlannerScreen(),
      const ForumScreen(),
      SettingScreen(user: widget.user),
    ];
  }

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
