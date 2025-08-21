import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../routers/app_router.dart';
import '../../../widgets/app_bottom_navigation_bar.dart';

class NavTabletLayout extends StatefulWidget {
  const NavTabletLayout({super.key});

  @override
  State<NavTabletLayout> createState() => _NavTabletLayoutState();
}

class _NavTabletLayoutState extends State<NavTabletLayout> {
  List<AppBottomNavigationItem> items = [
    AppBottomNavigationItem(
      selectedIcon: const Icon(Icons.home),
      icon: const Icon(Icons.home),
      label: 'Home',
      page: WorkspaceListRoute(),
    ),
    AppBottomNavigationItem(
      selectedIcon: const Icon(Icons.home),
      icon: const Icon(Icons.home),
      label: 'Home Detail',
      page: WorkspaceDetailRoute(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: items.map((e) => e.page).toList(),
      builder: (context, child) {
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: 1,
                onDestinationSelected: (_) {},
                leadingAtTop: false,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person),
                    label: Text('Profile'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
                  ),
                ],
              ),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }

  // AppBottomNavigationBar _getNavigationBar() {
  //   return AppBottomNavigationBar(items: items, currentIndex: 0);
  // }
}
