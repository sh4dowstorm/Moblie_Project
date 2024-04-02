import 'package:flutter/material.dart';
import 'package:mobile_project/models/user.dart' as appUser;
import 'package:ionicons/ionicons.dart';
import 'package:mobile_project/screens/home_screen.dart';
import 'package:mobile_project/screens/planner_screen.dart';
import 'package:mobile_project/screens/setting_screen.dart';
import 'package:mobile_project/services/current_user.dart';
import 'package:mobile_project/widgets/nav_bar.dart';
import 'package:provider/provider.dart';

class MainLayoutScreen extends StatefulWidget {
  final appUser.User user;

  const MainLayoutScreen({super.key, required this.user});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const PlannerScreen(),
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
    return ChangeNotifierProvider(
      create: (context) => CurrentUser(inUse: widget.user),
      child: SafeArea(
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
              {
                'fill': Ionicons.home,
                'outline': Ionicons.home_outline,
              },
              {
                'fill': Ionicons.create,
                'outline': Ionicons.create_outline,
              },
              {
                'fill': Ionicons.menu,
                'outline': Ionicons.menu_outline,
              },
            ],
          ),
        ),
      ),
    );
  }
}
