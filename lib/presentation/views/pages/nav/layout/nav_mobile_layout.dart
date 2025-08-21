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
    return AutoTabsScaffold(
      routes: items.map((e) => e.page).toList(),
      bottomNavigationBuilder: (context, tabsRouter) {
        return _getNavigationBar();
      },
    );
  }

  AppBottomNavigationBar _getNavigationBar() {
    return AppBottomNavigationBar(items: items, currentIndex: 0);
  }
}
