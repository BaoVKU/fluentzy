import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/core/navigation_destinations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  final Widget child;
  final Uri uri;
  const MainScreen({super.key, required this.uri, required this.child});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
                      NavigationDestinations.getList(context)
                          .map(
                            (dest) => NavigationRailDestination(
                              icon: dest.icon,
                              label: Text(dest.label),
                            ),
                          )
                          .toList(),
                  selectedIndex: NavigationDestinations.paths.indexOf(
                    widget.uri.path,
                  ),
                  onDestinationSelected: (int index) {
                    context.go(NavigationDestinations.paths[index]);
                  },
                ),
              Expanded(child: widget.child),
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
                    selectedIndex: NavigationDestinations.paths.indexOf(
                      widget.uri.path,
                    ),
                    onDestinationSelected: (int index) {
                      context.go(NavigationDestinations.paths[index]);
                    },
                    destinations: NavigationDestinations.getList(context),
                  )
                  : null,
        );
      },
    );
  }
}
