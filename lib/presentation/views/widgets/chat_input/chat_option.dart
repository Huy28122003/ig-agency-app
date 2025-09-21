import 'package:flutter/material.dart';

import '../../../../gen/assets.gen.dart';
import '../../../resources/colors.dart';

class ChatOption extends StatelessWidget {
  const ChatOption({
    super.key,
    this.hasOptions = false,
    this.onDocumentTap,
    this.onCameraTap,
    this.onMediaTap,
    this.onToggleOptions,
  });

  final bool hasOptions;
  final VoidCallback? onDocumentTap;
  final VoidCallback? onCameraTap;
  final VoidCallback? onMediaTap;
  final VoidCallback? onToggleOptions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 100),
        transitionBuilder: (child, animation) {
          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );

          if (child.key == const Key('options-bar')) {
            final slide =
                Tween<Offset>(
                  begin: const Offset(-0.1, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                );
            return SlideTransition(
              position: slide,
              child: FadeTransition(opacity: fade, child: child),
            );
          } else {
            return FadeTransition(opacity: fade, child: child);
          }
        },
        child: hasOptions
            ? Padding(
                key: const Key('options-bar'),
                padding: const EdgeInsets.only(left: 12),
                child: _buildOptionsBar(),
              )
            : Padding(
                key: const Key('arrow'),
                padding: const EdgeInsets.only(left: 10),
                child: _buildArrow(),
              ),
      ),
    );

    // if (hasOptions) {
    //   return Padding(
    //     padding: const EdgeInsets.only(left: 12),
    //     child: _buildOptionsBar(),
    //   );
    // }
    // return Padding(
    //   padding: const EdgeInsets.only(left: 10),
    //   child: _buildArrow(),
    // );
  }

  Widget _buildOptionsBar() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onDocumentTap,
          child: Container(
            height: 44,
            width: 44,
            alignment: Alignment.center,
            child: Assets.icons.icDocumentPrimary.svg(width: 24, height: 24),
          ),
        ),
        GestureDetector(
          onTap: onCameraTap,
          child: Container(
            height: 44,
            width: 44,
            alignment: Alignment.center,
            child: Assets.icons.icCameraPrimary.svg(width: 24, height: 24),
          ),
        ),
        GestureDetector(
          onTap: onMediaTap,
          child: Container(
            height: 44,
            width: 44,
            alignment: Alignment.center,
            child: Assets.icons.icAlbumPrimary.svg(width: 24, height: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildArrow() {
    return Container(
      height: 44,
      width: 44,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: onToggleOptions,
        child: RotatedBox(
          quarterTurns: 2,
          child: Assets.icons.icArrowLeft.svg(
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.textDefaultTextDefault,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
