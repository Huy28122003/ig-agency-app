import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';

class ProfileOptionItem extends StatelessWidget {
  final String title;
  final String iconPath;
  final String? subtitle;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const ProfileOptionItem({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
    this.subtitle,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        padding: EdgeInsets.only(
          top: isFirst ? 26 : 18,
          bottom: isLast ? 26 : 18,
          left: 16,
          right: 16,
        ),
        child: Row(
          spacing: 20,
          children: [
            Expanded(
              child: Row(
                spacing: 12,
                children: [
                  SvgPicture.asset(iconPath, width: 24, height: 24),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textDefaultTextDefault,
                        fontSize: 16,
                        fontFamily: FontFamily.segoeUI,
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 102),
                      child: Text(
                        subtitle!,
                        style: TextStyle(
                          color: AppColors.textDefaultTextSub,
                          fontSize: 14,
                          fontFamily: FontFamily.segoeUI,
                          fontWeight: FontWeight.w600,
                          height: 1.43,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            Assets.icons.icNext.svg(
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                AppColors.iconDefaultDefault,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
