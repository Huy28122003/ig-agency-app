import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/nav/nav_bloc.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../resources/colors.dart';
import '../../../../routers/app_router.dart';

class NavDesktopLayout extends StatelessWidget {
  const NavDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerGrayStrong1,
      body: SafeArea(
        bottom: false,
        child: Container(
          color: AppColors.surfaceContainerGrayStrong1,
          child: LayoutBuilder(
            builder: (context, boxConstraints) {
              return Row(
                children: [
                  Container(
                    color: AppColors.surfaceContainerGrayStrong1,
                    width: boxConstraints.maxWidth * 0.45,
                    constraints: BoxConstraints(
                      minWidth: 64 + 240,
                      maxWidth: 380,
                    ),
                    child: BlocBuilder<NavBloc, NavState>(
                      buildWhen: (pre, cur) =>
                          pre.currentIndex != cur.currentIndex,
                      builder: (context, state) {
                        return AutoTabsRouter(
                          lazyLoad: true,
                          routes: const [
                            GroupListRoute(),
                            SearchRoute(),
                            SettingRoute(),
                          ],
                          builder: (context, child) {
                            final tabsRouter = AutoTabsRouter.of(context);
                            return Row(
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    splashFactory: NoSplash.splashFactory,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                  ),
                                  child: NavigationRail(
                                    backgroundColor:
                                        AppColors.surfaceContainerGrayStrong1,
                                    useIndicator: true,
                                    extended: false,
                                    minWidth: 64,
                                    indicatorColor: Colors.transparent,
                                    labelType: NavigationRailLabelType.none,
                                    selectedIndex: state.currentIndex,
                                    onDestinationSelected: (int index) {
                                      tabsRouter.setActiveIndex(index);
                                      context.read<NavBloc>().add(
                                        OnChangeTabEvent(index),
                                      );
                                      context.router.replace(EmptyRoute());
                                    },
                                    destinations: <NavigationRailDestination>[
                                      NavigationRailDestination(
                                        selectedIcon: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16.0,
                                          ),
                                          child: Row(
                                            children: [
                                              RotatedBox(
                                                quarterTurns: 1,
                                                child: Assets.icons.icIndicator
                                                    .svg(),
                                              ),
                                              SizedBox(width: 8),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Assets.icons.icWorkspace.svg(
                                                  colorFilter: ColorFilter.mode(
                                                    AppColors
                                                        .textPrimaryTextDefault,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        icon: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Opacity(
                                                opacity: 0,
                                                child: RotatedBox(
                                                  quarterTurns: 1,
                                                  child: Assets
                                                      .icons
                                                      .icIndicator
                                                      .svg(),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Assets.icons.icWorkspace.svg(
                                                  colorFilter: ColorFilter.mode(
                                                    AppColors
                                                        .textDefaultTextSub2,
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
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16.0,
                                          ),
                                          child: Row(
                                            children: [
                                              RotatedBox(
                                                quarterTurns: 1,
                                                child: Assets.icons.icIndicator
                                                    .svg(),
                                              ),
                                              SizedBox(width: 8),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Assets.icons.icSearch.svg(
                                                  colorFilter: ColorFilter.mode(
                                                    AppColors
                                                        .textPrimaryTextDefault,
                                                    BlendMode.srcIn,
                                                  ),
                                                  width: 24,
                                                  height: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        icon: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Opacity(
                                                opacity: 0,
                                                child: RotatedBox(
                                                  quarterTurns: 1,
                                                  child: Assets
                                                      .icons
                                                      .icIndicator
                                                      .svg(),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Assets.icons.icSearch.svg(
                                                  width: 24,
                                                  height: 24,
                                                  colorFilter: ColorFilter.mode(
                                                    AppColors
                                                        .textDefaultTextSub2,
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
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16.0,
                                          ),
                                          child: Row(
                                            children: [
                                              RotatedBox(
                                                quarterTurns: 1,
                                                child: Assets.icons.icIndicator
                                                    .svg(),
                                              ),
                                              SizedBox(width: 8),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Assets.icons.icSetting.svg(
                                                  colorFilter: ColorFilter.mode(
                                                    AppColors
                                                        .textPrimaryTextDefault,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        icon: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Opacity(
                                                opacity: 0,
                                                child: RotatedBox(
                                                  quarterTurns: 1,
                                                  child: Assets
                                                      .icons
                                                      .icIndicator
                                                      .svg(),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Assets.icons.icSetting.svg(
                                                  colorFilter: ColorFilter.mode(
                                                    AppColors
                                                        .textDefaultTextSub2,
                                                    BlendMode.srcIn,
                                                  ),
                                                  width: 24,
                                                  height: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        label: const SizedBox.shrink(),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 12),
                                    constraints: BoxConstraints(maxWidth: 350),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: child,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 12,
                        top: 12,
                        bottom: 12,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AutoRouter(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
