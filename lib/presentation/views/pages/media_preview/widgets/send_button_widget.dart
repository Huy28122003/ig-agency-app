import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';
import '../../../widgets/circle_network_avatar.dart';

class SendButtonWidget extends StatelessWidget {
  const SendButtonWidget({
    super.key,
    required this.avatar,
    required this.onTap,
  });

  final String avatar;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerAlphaAlphaWhite17,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppColors.outlineGrayStrong50),
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  CircleNetworkAvatar(imageUrl: avatar, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Send',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textDefaultTextInverted,
                      fontSize: 16,
                      fontFamily: FontFamily.segoeUI,
                      fontWeight: FontWeight.w600,
                      height: 24 / 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
