import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_bottom_navigation_bar.dart';

class NavMobileLayout extends StatefulWidget {
  const NavMobileLayout({super.key});

  @override
  State<NavMobileLayout> createState() => _NavMobileLayoutState();
}

class _NavMobileLayoutState extends State<NavMobileLayout> {
  List<AppBottomNavigationItem> items = [
    AppBottomNavigationItem(
      selectedIcon: const Icon(Icons.home_rounded),
      icon: const Icon(Icons.home),
      label: 'Workspace',
      page: WorkspaceRoute(),
    ),
    AppBottomNavigationItem(
      selectedIcon: const Icon(Icons.search),
      icon: const Icon(Icons.search),
      label: 'Search',
      page: SearchRoute(),
    ),
    AppBottomNavigationItem(
      selectedIcon: const Icon(Icons.settings),
      icon: const Icon(Icons.settings),
      label: 'Setting',
      page: SettingHomeRoute(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      lazyLoad: true,
      routes: items.map((e) => e.page).toList(),
      bottomNavigationBuilder: (context, tabsRouter) {
        return AppBottomNavigationBar(
          items: items,
          currentIndex: tabsRouter.activeIndex,
          onTap: (index) {
            tabsRouter.setActiveIndex(index);
          },
        );
      },
    );
  }
}
