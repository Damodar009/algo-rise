import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:alarm/alarm.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/pages/alarm/alarms_page.dart';
import 'package:algo_rise/src/pages/home/home_page.dart';
import 'package:algo_rise/src/pages/profile/profile_page.dart';
import 'package:algo_rise/src/pages/progress/progress_page.dart';
import 'package:algo_rise/src/widgets/bottom_nav.dart';

class MainNavigationPage extends StatefulWidget {
  static const String routeName = '/main';

  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;
  StreamSubscription<dynamic>? _ringSubscription;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(isNested: true),
      const AlarmsPage(isNested: true),
      const ProgressPage(),
      const ProfilePage(),
    ];

    // Listen to native alarm triggers
    _ringSubscription = Alarm.ringing.listen((alarmSet) {
      if (alarmSet.alarms.isNotEmpty && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.push('/alarm/ringing');
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _ringSubscription?.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
