import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme/colors.dart';

enum NavTab { home, forecast, settings }

class TemporaBottomNavBar extends StatelessWidget {
  const TemporaBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  final NavTab currentTab;
  final ValueChanged<NavTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 24,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                color: TemporaColors.surface.withAlpha(204), // ~80%
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: TemporaColors.rimLight,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(120),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _NavItem(
                    icon: Symbols.grid_view,
                    tab: NavTab.home,
                    current: currentTab,
                    onTap: onTabSelected,
                  ),
                  const SizedBox(width: 24),
                  _NavItem(
                    icon: Symbols.calendar_month,
                    tab: NavTab.forecast,
                    current: currentTab,
                    onTap: onTabSelected,
                  ),
                  const SizedBox(width: 24),
                  _NavItem(
                    icon: Symbols.settings,
                    tab: NavTab.settings,
                    current: currentTab,
                    onTap: onTabSelected,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.tab,
    required this.current,
    required this.onTap,
  });

  final IconData icon;
  final NavTab tab;
  final NavTab current;
  final ValueChanged<NavTab> onTap;

  bool get _isActive => tab == current;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(tab),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: _isActive
            ? Icon(
                icon,
                size: 26,
                color: TemporaColors.cyan,
                fill: 0.0,
                weight: 300,
                shadows: [
                  Shadow(
                    color: TemporaColors.cyanGlow,
                    blurRadius: 10,
                  ),
                ],
              )
            : Icon(
                icon,
                size: 24,
                color: TemporaColors.onSurface.withAlpha(100),
                fill: 0.0,
                weight: 300,
              ),
      ),
    );
  }
}
