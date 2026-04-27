import 'package:flutter/material.dart';
import 'core/theme/colors.dart';
import 'core/widgets/bottom_nav_bar.dart';
import 'features/weather/presentation/screens/main_weather_screen.dart';
import 'features/weather/presentation/screens/forecast_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  NavTab _currentTab = NavTab.home;

  static const _screens = <Widget>[
    MainWeatherScreen(),
    ForecastScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TemporaColors.black,
      body: Stack(
        children: [
          // Screens preserved in memory — no rebuild on tab switch
          IndexedStack(
            index: _currentTab.index,
            children: _screens,
          ),

          // Floating pill nav on top
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: TemporaBottomNavBar(
              currentTab: _currentTab,
              onTabSelected: (tab) => setState(() => _currentTab = tab),
            ),
          ),
        ],
      ),
    );
  }
}
