import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';

import '../../../../../../gen/assets.gen.dart';

class SuperMenuPopupMobileWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onTapMask;
  final VoidCallback onTapPin;
  final VoidCallback onTapMute;
  final VoidCallback onTapDelete;
  final bool isMute;
  final bool isPin;
  final bool isSeen;

  const SuperMenuPopupMobileWidget({
    super.key,
    required this.child,
    required this.onTapMask,
    required this.onTapPin,
    required this.onTapMute,
    required this.onTapDelete,
    required this.isMute,
    required this.isPin,
    required this.isSeen,
  });

  @override
  State<SuperMenuPopupMobileWidget> createState() =>
      _SuperMenuPopupMobileWidgetState();
}

class _SuperMenuPopupMobileWidgetState
    extends State<SuperMenuPopupMobileWidget> {
  OverlayEntry? _overlayEntry;

  void _showPopup(BuildContext context, Size screenSize) {
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _hidePopup,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(color: Colors.white.withValues(alpha: 0.17)),
                ),
              ),
            ),
            Positioned(
              top: position.dy,
              left: 0,
              right: 0,
              child: Material(child: widget.child),
            ),

            Positioned(
              left: screenSize.width / 2 - 250 / 2,
              top: (position.dy + size.height + 224 + 5 > screenSize.height
                  ? position.dy - 185
                  : position.dy + size.height + 5),
              child: Material(
                color: Colors.transparent,
                child: _MenuPopup(
                  isSeen: widget.isSeen,
                  isPin: widget.isPin,
                  isMute: widget.isMute,
                  onTapMask: () {
                    _hidePopup();
                    widget.onTapMask();
                  },
                  onTapPin: () {
                    _hidePopup();
                    widget.onTapPin();
                  },
                  onTapMute: () {
                    _hidePopup();
                    widget.onTapMute();
                  },
                  onTapDelete: () {
                    _hidePopup();
                    widget.onTapDelete();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hidePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: widget.child,
      onLongPress: () {
        _showPopup(context, size);
      },
    );
  }
}

class _MenuPopup extends StatefulWidget {
  final VoidCallback onTapMask;
  final VoidCallback onTapPin;
  final VoidCallback onTapMute;
  final VoidCallback onTapDelete;
  final bool isMute;
  final bool isPin;
  final bool isSeen;

  const _MenuPopup({
    required this.onTapMask,
    required this.onTapPin,
    required this.onTapMute,
    required this.onTapDelete,
    required this.isMute,
    required this.isPin,
    required this.isSeen,
  });

  @override
  State<_MenuPopup> createState() => _MenuPopupState();
}

class _MenuPopupState extends State<_MenuPopup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 32,
            offset: Offset(0, 0),
          ),
        ],
      ),
      width: 250,
      child: Column(
        children: [
          _buildItem(
            title: widget.isSeen
                ? "workspace.mark_as_unread".tr()
                : "workspace.mark_as_read".tr(),
            onTap: widget.onTapMask,
            icon: widget.isSeen
                ? Assets.icons.icLetter.svg()
                : Assets.icons.icLetterOpen.svg(),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: Color(0xFF808080).withValues(alpha: 0.55),
          ),
          _buildItem(
            title: widget.isPin ? "workspace.unpin".tr() : "workspace.pin".tr(),
            onTap: widget.onTapPin,
            icon: widget.isPin
                ? Assets.icons.icUnpin.svg()
                : Assets.icons.icPin.svg(),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: Color(0xFF808080).withValues(alpha: 0.55),
          ),
          _buildItem(
            title: widget.isMute
                ? "workspace.unmute".tr()
                : "workspace.mute".tr(),
            onTap: widget.onTapMute,
            icon: widget.isMute
                ? Assets.icons.icBlockNotification.svg()
                : Assets.icons.icNotification.svg(),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: Color(0xFF808080).withValues(alpha: 0.55),
          ),
          _buildItem(
            title: "workspace.delete".tr(),
            onTap: widget.onTapDelete,
            textStyle: TextStyle(
              color: Color(0xFFFF3B30),
              fontWeight: FontWeight.w400,
              fontFamily: FontFamily.segoeUI,
              fontSize: 16,
              height: 24 / 16,
            ),
            icon: Assets.icons.icTrash.svg(),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required String title,
    required VoidCallback onTap,
    Widget? icon,
    TextStyle? textStyle,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style:
                textStyle ??
                    TextStyle(
                      color: AppColors.textDefaultTextDefault,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontFamily.segoeUI,
                      fontSize: 16,
                      height: 24 / 16,
                    ),
              ),
            ),
            if (icon != null) icon,
          ],
        ),
      ),
    );
  }
}
