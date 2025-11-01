import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';

class SetAvatarButton extends StatelessWidget {
  const SetAvatarButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerAlphaAlphaWhite17,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: AppColors.outlineGrayStrong50,
                  width: 0.75,
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Text(
                    'media_preview.set_as_avatar'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textDefaultTextInverted,
                      fontSize: 16,
                      fontFamily: FontFamily.segoeUI,
                      fontWeight: FontWeight.w600,
                      height: 24 / 16,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Assets.icons.icArrowRight2.svg(width: 16, height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
