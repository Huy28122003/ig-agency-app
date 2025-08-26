import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/nav/nav_bloc.dart';

import '../../../../routers/app_router.dart';

class NavTabletLayout extends StatelessWidget {
  const NavTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<NavBloc, NavState>(
          buildWhen: (pre, cur) => pre.currentIndex != cur.currentIndex,
          builder: (context, state) {
            return AutoTabsRouter(
              lazyLoad: true,
              routes: const [
                WorkspaceListRoute(),
                SearchRoute(),
                SettingRoute(),
              ],
              builder: (context, child) {
                final tabsRouter = AutoTabsRouter.of(context);
                return Row(
                  children: [
                    NavigationRail(
                      extended: false,
                      minWidth: 80,
                      selectedIndex: state.currentIndex,
                      onDestinationSelected: (int index) {
                        tabsRouter.setActiveIndex(index);
                      },
                      destinations: const <NavigationRailDestination>[
                        NavigationRailDestination(
                          icon: Badge(
                            label: Text('4'),
                            child: Icon(Icons.chat_bubble_outline),
                          ),
                          selectedIcon: Icon(Icons.chat_bubble),
                          label: Text('First'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.search_outlined),
                          selectedIcon: Icon(Icons.search),
                          label: Text('Second'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.settings),
                          selectedIcon: Icon(Icons.settings),
                          label: Text('Third'),
                        ),
                      ],
                    ),
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
        ),
        Container(color: Colors.black, width: 1, height: double.infinity),
        Expanded(flex: 2, child: AutoRouter()),
      ],
    );
  }
}
