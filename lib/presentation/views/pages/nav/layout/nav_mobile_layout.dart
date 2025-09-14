import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_bottom_navigation_bar.dart';

import '../../../../../gen/assets.gen.dart';

class NavMobileLayout extends StatefulWidget {
  const NavMobileLayout({super.key});

  @override
  State<NavMobileLayout> createState() => _NavMobileLayoutState();
}

class _NavMobileLayoutState extends State<NavMobileLayout> {
  List<AppBottomNavigationItem> items = [
    AppBottomNavigationItem(
      selectedIcon: Assets.icons.icWorkspace.svg(
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          AppColors.textPrimaryTextDefault,
          BlendMode.srcIn,
        ),
      ),
      icon: Assets.icons.icWorkspace.svg(
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          AppColors.textDefaultTextSub2,
          BlendMode.srcIn,
        ),
      ),
      label: 'Workspace',
      page: WorkspaceListRoute(),
    ),
    AppBottomNavigationItem(
      selectedIcon: Assets.icons.icSearch.svg(
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          AppColors.textPrimaryTextDefault,
          BlendMode.srcIn,
        ),
      ),
      icon: Assets.icons.icSearch.svg(
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          AppColors.textDefaultTextSub2,
          BlendMode.srcIn,
        ),
      ),
      label: 'Search',
      page: SearchRoute(),
    ),
    AppBottomNavigationItem(
      selectedIcon: Assets.icons.icAdmin.svg(
        colorFilter: ColorFilter.mode(
          AppColors.textPrimaryTextDefault,
          BlendMode.srcIn,
        ),
      ),
      icon: Assets.icons.icAdmin.svg(
        colorFilter: ColorFilter.mode(
          AppColors.textDefaultTextSub2,
          BlendMode.srcIn,
        ),
      ),
      label: 'Admin',
      page: DashboardHomeRoute(),
    ),
    AppBottomNavigationItem(
      selectedIcon: Assets.icons.icSetting.svg(
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          AppColors.textPrimaryTextDefault,
          BlendMode.srcIn,
        ),
      ),
      icon: Assets.icons.icSetting.svg(
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          AppColors.textDefaultTextSub2,
          BlendMode.srcIn,
        ),
      ),
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
