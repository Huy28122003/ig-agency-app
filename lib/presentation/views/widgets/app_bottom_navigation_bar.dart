import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class AppBottomNavigationItem {
  AppBottomNavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.page,
  });

  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final PageRouteInfo page;
}

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onTap,
  });

  final List<AppBottomNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 82),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          return GestureDetector(
            onTap: () => onTap?.call(index),
            child: Column(
              children: [Text(items[index].label), Icon(Icons.add)],
            ),
          );
        }),
      ),
    );
  }
}
