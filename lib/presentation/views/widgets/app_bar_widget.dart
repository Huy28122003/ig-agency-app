import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/shared/extensions/string.dart';

import '../../../gen/assets.gen.dart';
import '../../../gen/fonts.gen.dart';
import '../../resources/colors.dart';

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
    : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  AppBarWidget({
    super.key,
    this.bottom,
    this.leading,
    this.title,
    this.actions = const [],
    this.automaticallyImplyLeading = false,
    this.onTapToTitle,
    this.center,
    this.titleStyle,
    this.backgroundColor,
    this.toolbarHeight = 60,
  }) : preferredSize = _PreferredAppBarSize(
         toolbarHeight ?? kToolbarHeight,
         bottom?.preferredSize.height,
       );

  @override
  final Size preferredSize;
  final PreferredSizeWidget? bottom;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? center;
  final String? title;
  final TextStyle? titleStyle;
  final List<Widget> actions;
  final GestureTapCallback? onTapToTitle;
  final Color? backgroundColor;
  final double? toolbarHeight;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          backgroundColor ?? AppColors.surfaceContainerPrimaryPrimaryDefault,
      elevation: 0,
      toolbarHeight: toolbarHeight,
      title: center ?? _buildTitle(),
      centerTitle: true,
      leadingWidth: 52,
      leading: Container(
        padding: const EdgeInsets.only(left: 4),
        alignment: Alignment.centerLeft,
        child: !automaticallyImplyLeading
            ? Row(children: actions)
            : IconButton(
                padding: EdgeInsets.all(8),
                onPressed: () {
                  context.router.pop();
                },
                icon: Assets.icons.icArrowLeft.svg(
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    AppColors.iconDefaultDefaultInverted,
                    BlendMode.srcIn,
                  ),
                ),
              ),
      ),
      bottom: bottom,
    );
  }

  Widget? _buildTitle() {
    return title.isNullOrEmpty()
        ? null
        : Text(
            title ?? '',
            style:
                titleStyle ??
                TextStyle(
                  color: AppColors.textDefaultTextInverted,
                  fontSize: 22,
                  fontFamily: FontFamily.segoeUI,
                  fontWeight: FontWeight.w700,
                  height: 1.27,
                ),
          );
  }
}
