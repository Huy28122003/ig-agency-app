import 'package:flutter/material.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';

class EmptyPinnedMessage extends StatelessWidget {
  const EmptyPinnedMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(20),
        constraints: BoxConstraints(maxWidth: 240),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            Assets.images.bgEmptyPinnedMessages.image(width: 160, height: 160),
            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                Text(
                  'No pinned messages',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textDefaultTextDefault,
                    fontSize: 24,
                    fontFamily: FontFamily.segoeUI,
                    fontWeight: FontWeight.w700,
                    height: 1.17,
                  ),
                ),
                Text(
                  'Messages pinned from this chat will appear here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textDefaultTextSub2,
                    fontSize: 16,
                    fontFamily: FontFamily.segoeUI,
                    fontWeight: FontWeight.w400,
                    height: 1.75,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
