import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';

const _kDividerHeight = 0.5;
const _kMenuWidth = 250.0;
const _kActionHeight = 44.0;
const _kBorderRadius = 12.0;
const _kDefaultGapBetweenChildAndMenu = 12.0;

enum MenuAlignment { left, center, right }

class CustomContextMenuAction {
  const CustomContextMenuAction({
    this.text,
    this.textStyle,
    this.trailingIcon,
    this.onTap,
  });

  final String? text;
  final TextStyle? textStyle;
  final Widget? trailingIcon;
  final VoidCallback? onTap;

  Widget child(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text!,
              style:
                  textStyle ??
                  TextStyle(
                    color: AppColors.textDefaultTextDefault,
                    fontSize: 16,
                    fontFamily: FontFamily.segoeUI,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                    letterSpacing: -0.43,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 8),
            trailingIcon!,
          ],
        ],
      ),
    );
  }
}

class CustomContextMenu extends StatefulWidget {
  const CustomContextMenu({
    super.key,
    required this.child,
    required this.actions,
    this.menuAlignment = MenuAlignment.center,
    this.childAlignment = MenuAlignment.left,
    this.horizontalPadding,
  });

  final Widget child;
  final List<CustomContextMenuAction> actions;
  final MenuAlignment menuAlignment;
  final MenuAlignment childAlignment;
  final double? horizontalPadding;

  @override
  State<CustomContextMenu> createState() => _CustomContextMenuState();
}

class _CustomContextMenuState extends State<CustomContextMenu>
    with SingleTickerProviderStateMixin {
  final GlobalKey _childKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _showContextMenu() {
    final context = _childKey.currentContext;
    final renderBox = context?.findRenderObject() as RenderBox?;
    if (context == null || renderBox == null) {
      return;
    }

    final Size childSize = renderBox.size;
    final Offset childOffset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  final double opacity = _animationController.value;
                  return Positioned.fill(
                    child: GestureDetector(
                      onTap: _hideContextMenu,
                      child: Opacity(opacity: opacity, child: child),
                    ),
                  );
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: 0.17),
                    child: SizedBox.expand(),
                  ),
                ),
              ),
              _ContextMenuContent(
                animation: _animationController,
                childOffset: childOffset,
                childSize: childSize,
                actions: widget.actions,
                menuWidth: _kMenuWidth,
                actionHeight: _kActionHeight,
                borderRadius: BorderRadius.circular(_kBorderRadius),
                menuAlignment: widget.menuAlignment,
                childAlignment: widget.childAlignment,
                horizontalPadding: widget.horizontalPadding,
                onActionTapped: _hideContextMenu,
                child: widget.child,
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward(from: 0.0);
  }

  void _hideContextMenu() {
    if (_overlayEntry == null) return;
    _animationController.reverse().then((value) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Actions is empty
    if (widget.actions.isEmpty) {
      return widget.child;
    }
    return GestureDetector(
      key: _childKey,
      onLongPress: _showContextMenu,
      child: widget.child,
    );
  }
}

class _ContextMenuContent extends StatelessWidget {
  const _ContextMenuContent({
    required this.animation,
    required this.childOffset,
    required this.childSize,
    required this.actions,
    required this.menuWidth,
    required this.actionHeight,
    required this.borderRadius,
    required this.onActionTapped,
    required this.child,
    this.menuAlignment = MenuAlignment.center,
    this.childAlignment = MenuAlignment.left,
    this.horizontalPadding,
  });

  final AnimationController animation;
  final Offset childOffset;
  final Size childSize;
  final List<CustomContextMenuAction> actions;
  final double menuWidth;
  final double actionHeight;
  final BorderRadius borderRadius;
  final VoidCallback onActionTapped;
  final Widget child;
  final MenuAlignment menuAlignment;
  final MenuAlignment childAlignment;
  final double? horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final safeAreaPadding = mediaQuery.padding;
    final viewInsets = mediaQuery.viewInsets;

    final double menuHeight =
        actions.length * actionHeight +
        (actions.length > 1 ? (actions.length - 1) * _kDividerHeight : 0);

    double menuCalculatedLeft;
    switch (menuAlignment) {
      case MenuAlignment.left:
        menuCalculatedLeft = horizontalPadding ?? childOffset.dx;
        break;
      case MenuAlignment.center:
        menuCalculatedLeft = screenWidth / 2 - (menuWidth / 2);
        break;
      case MenuAlignment.right:
        menuCalculatedLeft = horizontalPadding != null
            ? (screenWidth - horizontalPadding! - menuWidth)
            : (childOffset.dx + childSize.width - menuWidth);
        break;
    }

    menuCalculatedLeft = menuCalculatedLeft.clamp(
      safeAreaPadding.left,
      screenWidth -
          menuWidth -
          (horizontalPadding ?? 0) -
          safeAreaPadding.right,
    );

    double childCalculatedLeft;
    switch (childAlignment) {
      case MenuAlignment.left:
        childCalculatedLeft = horizontalPadding ?? childOffset.dx;
        break;
      case MenuAlignment.center:
        childCalculatedLeft = screenWidth / 2 - (childSize.width / 2);
        break;
      case MenuAlignment.right:
        childCalculatedLeft = horizontalPadding != null
            ? (screenWidth - horizontalPadding! - childSize.width)
            : childOffset.dx;
        break;
    }

    childCalculatedLeft = childCalculatedLeft.clamp(
      safeAreaPadding.left,
      screenWidth -
          childSize.width -
          (horizontalPadding ?? 0) -
          safeAreaPadding.right,
    );

    final double deltaX = childCalculatedLeft - childOffset.dx;

    Widget menuWidgetContent = Material(
      color: Colors.transparent,
      child: Container(
        width: menuWidth,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          shadows: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 32,
              offset: Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return SizedBox(
              height: actionHeight,
              width: menuWidth,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  action.onTap?.call();
                  onActionTapped.call();
                },
                child: action.child(context),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: _kDividerHeight,
              thickness: _kDividerHeight,
              color: Color(0x8C808080),
            );
          },
        ),
      ),
    );

    final double totalCombinedHeight =
        childSize.height + menuHeight + _kDefaultGapBetweenChildAndMenu;
    final double availableVerticalSpace =
        screenHeight -
        safeAreaPadding.top -
        (safeAreaPadding.bottom == 0 ? 10 : safeAreaPadding.bottom) -
        viewInsets.top -
        viewInsets.bottom;
    final bool needsScrolling = totalCombinedHeight > availableVerticalSpace;

    if (needsScrolling) {
      // TODO hoannk: Hadnle this case
      return SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: SingleChildScrollView(
          reverse: true,
          child: GestureDetector(
            onTap: () {
              print('onTap');
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: _kDefaultGapBetweenChildAndMenu,
              children: [child, menuWidgetContent],
            ),
          ),
        ),
      );
    } else {
      final double idealCombinedContentTop = childOffset.dy;
      double finalCombinedContentTop = idealCombinedContentTop;
      if (finalCombinedContentTop + totalCombinedHeight >
          screenHeight - safeAreaPadding.bottom - viewInsets.bottom) {
        finalCombinedContentTop =
            screenHeight -
            safeAreaPadding.bottom -
            viewInsets.bottom -
            totalCombinedHeight;
      }
      if (finalCombinedContentTop < safeAreaPadding.top + viewInsets.top) {
        finalCombinedContentTop = safeAreaPadding.top + viewInsets.top;
      }
      final double deltaY = finalCombinedContentTop - idealCombinedContentTop;

      return _Animation(
        animation: animation,
        deltaX: deltaX,
        deltaY: deltaY,
        childOffset: childOffset,
        childSize: childSize,
        menuCalculatedLeft: menuCalculatedLeft,
        menuWidgetContent: menuWidgetContent,
        child: child,
      );
    }
  }
}

class _Animation extends StatefulWidget {
  const _Animation({
    required this.child,
    required this.animation,
    required this.deltaX,
    required this.deltaY,
    required this.childOffset,
    required this.childSize,
    required this.menuCalculatedLeft,
    required this.menuWidgetContent,
  });

  final Widget child;
  final AnimationController animation;
  final double deltaX;
  final double deltaY;
  final Offset childOffset;
  final Size childSize;
  final double menuCalculatedLeft;
  final Widget menuWidgetContent;

  @override
  State<_Animation> createState() => _AnimationState();
}

class _AnimationState extends State<_Animation> {
  late final Animatable<double> _translateXTween;
  late final Animatable<double> _translateYTween;
  late final Animatable<double> _menuScaleTween;
  late final Animatable<double> _menuOpacityTween;

  @override
  void initState() {
    super.initState();
    _translateXTween = Tween<double>(
      begin: 0.0,
      end: widget.deltaX,
    ).chain(CurveTween(curve: Curves.easeOutCubic));
    _translateYTween = Tween<double>(
      begin: 0.0,
      end: widget.deltaY,
    ).chain(CurveTween(curve: Curves.easeOutCubic));
    _menuScaleTween = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).chain(CurveTween(curve: Curves.easeOutBack));
    _menuOpacityTween = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).chain(CurveTween(curve: Curves.easeOutCubic));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, childWidget) {
        final currentChildTranslateX = _translateXTween.evaluate(
          widget.animation,
        );
        final currentChildTranslateY = _translateYTween.evaluate(
          widget.animation,
        );
        final currentMenuScale = _menuScaleTween.evaluate(widget.animation);
        final currentMenuOpacity = _menuOpacityTween.evaluate(widget.animation);

        return Stack(
          children: [
            Positioned(
              left:
                  widget.childOffset.dx +
                  (widget.deltaX > 0
                      ? -currentChildTranslateX
                      : currentChildTranslateX),
              top: widget.childOffset.dy + currentChildTranslateY,
              width: widget.childSize.width,
              height: widget.childSize.height,
              child: widget.child,
            ),

            Positioned(
              left: widget.menuCalculatedLeft,
              top:
                  (widget.childOffset.dy +
                      widget.childSize.height +
                      _kDefaultGapBetweenChildAndMenu) +
                  currentChildTranslateY,
              child: Transform.scale(
                scale: currentMenuScale,
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: currentMenuOpacity,
                  child: widget.menuWidgetContent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
