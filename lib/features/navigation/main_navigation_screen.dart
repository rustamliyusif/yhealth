import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../l10n/app_localizations.dart';
import '../dashboard/dashboard_screen.dart';
import '../activity/activity_screen.dart';
import '../health/bmi_screen.dart';
import '../profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final screens = [
      DashboardScreen(onStartWalkTap: () => _switchTab(1)),
      const ActivityScreen(),
      const BmiScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          border: Border(
            top: BorderSide(color: AppColors.borderOf(context), width: 1),
          ),
          boxShadow: AppDecorations.cardShadow(context),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _switchTab,
          backgroundColor: AppColors.surfaceOf(context),
          indicatorColor: AppColors.primaryAccentOf(context).withValues(alpha: 0.18),
          elevation: 0,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded, color: AppColors.primaryAccentOf(context)),
              label: l10n.navHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.directions_walk_outlined),
              selectedIcon: Icon(Icons.directions_walk_rounded, color: AppColors.primaryAccentOf(context)),
              label: l10n.navActivity,
            ),
            NavigationDestination(
              icon: const Icon(Icons.favorite_outline_rounded),
              selectedIcon: Icon(Icons.favorite_rounded, color: AppColors.primaryAccentOf(context)),
              label: l10n.navHealth,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded, color: AppColors.primaryAccentOf(context)),
              label: l10n.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
