import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/core/navigation_destinations.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        final isMediumScreen = constraint.maxWidth > 600;
        final isLargeScreen = constraint.maxWidth > 1200;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Row(
            children: [
              if (isMediumScreen)
                NavigationRail(
                  backgroundColor: AppColors.surface,
                    indicatorShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    indicatorColor: AppColors.surfacePrimary,
                  extended: isLargeScreen,
                  destinations:
                      NavigationDestinations.list
                          .map(
                            (dest) => NavigationRailDestination(
                              icon: dest.icon,
                              label: Text(dest.label),
                            ),
                          )
                          .toList(),
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() => _selectedIndex = index);
                  },
                ),
              Expanded(child: NavigationDestinations.pages[_selectedIndex]),
            ],
          ),
          bottomNavigationBar:
              !isMediumScreen
                  ? NavigationBar(
                    backgroundColor: AppColors.surface,
                    indicatorShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    indicatorColor: AppColors.surfacePrimary,
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (int index) {
                      setState(() => _selectedIndex = index);
                    },
                    destinations: NavigationDestinations.list,
                  )
                  : null,
        );
      },
    );
  }
}
