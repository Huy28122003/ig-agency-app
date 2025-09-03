import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';

import '../../../gen/assets.gen.dart';

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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border(top: BorderSide(color: AppColors.outlineGrayStrong200)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -2),
            blurRadius: 4,
            color: Colors.white.withValues(alpha: 0.04),
          ),
        ],
      ),
      constraints: const BoxConstraints(maxHeight: 82),
      padding: EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          return GestureDetector(
            onTap: () => onTap?.call(index),
            child: Column(
              children: [
                (currentIndex == index)
                    ? items[index].selectedIcon
                    : items[index].icon,
                SizedBox(height: 4),
                Text(
                  items[index].label,
                  style: TextStyle(
                    color: currentIndex == index
                        ? AppColors.textPrimaryTextDefault
                        : AppColors.textDefaultTextSub2,
                    fontFamily: FontFamily.segoeUI,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    height: 14 / 10,
                  ),
                ),
                Spacer(),
                if (currentIndex == index) Assets.icons.icIndicator.svg(),
              ],
            ),
          );
        }),
      ),
    );
  }
}
