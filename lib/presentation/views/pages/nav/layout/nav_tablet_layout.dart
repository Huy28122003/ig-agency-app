import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/enums/role.dart';
import 'package:ig_agency_app/presentation/views/pages/nav/nav_bloc.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../resources/colors.dart';
import '../../../../routers/app_router.dart';
import '../../../widgets/app_bottom_navigation_bar.dart';

class NavTabletLayout extends StatelessWidget {
  const NavTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NavBloc, NavState, RoleSystem>(
      selector: (state) => state.roleSystem,
      builder: (BuildContext context, RoleSystem roleSystem) {
        final isAdmin = roleSystem.isAdmin;
        List<AppBottomNavigationItem> items = _getItems(isAdmin);

        return Scaffold(
          backgroundColor: AppColors.surfaceContainerGrayStrong0,
          body: SafeArea(
            child: Container(
              color: AppColors.surfaceContainerGrayStrong1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: LayoutBuilder(
                  builder: (context, boxConstraints) {
                    return Row(
                      children: [
                        Container(
                          width: boxConstraints.maxWidth * 0.4,
                          constraints: BoxConstraints(
                            minWidth: 240,
                            maxWidth: 300,
                          ),
                          child: BlocBuilder<NavBloc, NavState>(
                            buildWhen: (pre, cur) =>
                                pre.currentIndex != cur.currentIndex,
                            builder: (context, state) {
                              return AutoTabsRouter(
                                lazyLoad: true,
                                routes: [
                                  WorkspaceListRoute(),
                                  SearchRoute(),
                                  if (isAdmin) DashboardHomeRoute(),
                                  SettingRoute(),
                                ],
                                builder: (context, child) {
                                  return BlocListener<NavBloc, NavState>(
                                    listenWhen: (pre, cur) {
                                      return pre.currentIndex !=
                                          cur.currentIndex;
                                    },
                                    listener: (_, state) {
                                      final index = state.currentIndex;
                                      AutoTabsRouter.of(
                                        context,
                                      ).setActiveIndex(index);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: child,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AutoRouter(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          bottomNavigationBar: BlocSelector<NavBloc, NavState, int>(
            selector: (state) => state.currentIndex,
            builder: (context, currentIndex) {
              return AppBottomNavigationBar(
                items: items,
                currentIndex: currentIndex,
                onTap: (index) {
                  context.read<NavBloc>().add(OnChangeTabEvent(index));
                },
              );
            },
          ),
        );
      },
    );
  }

  List<AppBottomNavigationItem> _getItems(bool isAdmin) {
    return [
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
      if (isAdmin)
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
  }
}
