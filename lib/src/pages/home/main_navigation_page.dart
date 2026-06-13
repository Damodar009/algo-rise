import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/pages/alarm/alarms_page.dart';
import 'package:algo_rise/src/pages/home/home_page.dart';
import 'package:algo_rise/src/pages/profile/profile_page.dart';
import 'package:algo_rise/src/pages/progress/progress_page.dart';
import 'package:algo_rise/src/widgets/bottom_nav.dart';
import 'package:algo_rise/src/widgets/permission_request_dialog.dart';

class MainNavigationPage extends StatefulWidget {
  static const String routeName = '/main';

  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(isNested: true),
      const AlarmsPage(isNested: true),
      const ProgressPage(),
      const ProfilePage(),
    ];

    // Check and request permissions if needed when app opens.
    // NOTE: Alarm ring navigation is handled globally in App (app.dart) via
    // Alarm.ringing stream, so no stream listener is needed here.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        PermissionRequestDialog.showIfNeeded(context);
      }
    });
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
