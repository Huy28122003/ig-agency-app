import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/nav/nav_bloc.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../resources/colors.dart';
import '../../../../routers/app_router.dart';

class NavTabletLayout extends StatelessWidget {
  const NavTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildNavigationRail(),
        Container(color: Colors.black, width: 1, height: double.infinity),
        Expanded(flex: 2, child: AutoRouter()),
      ],
    );
  }

  Widget _buildNavigationRail() {
    return BlocBuilder<NavBloc, NavState>(
      buildWhen: (pre, cur) => pre.currentIndex != cur.currentIndex,
      builder: (context, state) {
        return AutoTabsRouter(
          lazyLoad: true,
          routes: const [WorkspaceRoute(), SearchRoute(), SettingRoute()],
          builder: (context, child) {
            final tabsRouter = AutoTabsRouter.of(context);
            return Row(
              children: [
                NavigationRail(
                  useIndicator: true,
                  extended: false,
                  minWidth: 80,
                  selectedIndex: state.currentIndex,
                  indicatorColor: Colors.transparent,
                  labelType: NavigationRailLabelType.none,
                  onDestinationSelected: (int index) {
                    tabsRouter.setActiveIndex(index);
                    context.read<NavBloc>().add(OnChangeTabEvent(index));
                  },
                  destinations: <NavigationRailDestination>[
                    NavigationRailDestination(
                      selectedIcon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            RotatedBox(
                              quarterTurns: 1,
                              child: Assets.icons.icIndicator.svg(),
                            ),
                            SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Assets.icons.icWorkspace.svg(
                                colorFilter: ColorFilter.mode(
                                  AppColors.textPrimaryTextDefault,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            Opacity(
                              opacity: 0,
                              child: RotatedBox(
                                quarterTurns: 1,
                                child: Assets.icons.icIndicator.svg(),
                              ),
                            ),
                            SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Assets.icons.icWorkspace.svg(
                                colorFilter: ColorFilter.mode(
                                  AppColors.textDefaultTextSub2,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      label: const SizedBox.shrink(),
                    ),
                    NavigationRailDestination(
                      selectedIcon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            RotatedBox(
                              quarterTurns: 1,
                              child: Assets.icons.icIndicator.svg(),
                            ),
                            SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Assets.icons.icSearch.svg(
                                colorFilter: ColorFilter.mode(
                                  AppColors.textPrimaryTextDefault,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            Opacity(
                              opacity: 0,
                              child: RotatedBox(
                                quarterTurns: 1,
                                child: Assets.icons.icIndicator.svg(),
                              ),
                            ),
                            SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Assets.icons.icSearch.svg(
                                colorFilter: ColorFilter.mode(
                                  AppColors.textDefaultTextSub2,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      label: const SizedBox.shrink(),
                    ),
                    NavigationRailDestination(
                      selectedIcon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            RotatedBox(
                              quarterTurns: 1,
                              child: Assets.icons.icIndicator.svg(),
                            ),
                            SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Assets.icons.icSetting.svg(
                                colorFilter: ColorFilter.mode(
                                  AppColors.textPrimaryTextDefault,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            Opacity(
                              opacity: 0,
                              child: RotatedBox(
                                quarterTurns: 1,
                                child: Assets.icons.icIndicator.svg(),
                              ),
                            ),
                            SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Assets.icons.icSetting.svg(
                                colorFilter: ColorFilter.mode(
                                  AppColors.textDefaultTextSub2,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      label: const SizedBox.shrink(),
                    ),
                  ],
                ),

                //todo: de tam
                Container(
                  color: Colors.black,
                  width: 1,
                  height: double.infinity,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 250, minWidth: 200),
                  child: child,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
