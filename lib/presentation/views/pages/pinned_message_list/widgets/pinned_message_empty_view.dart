import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';

class PinnedMessageEmptyView extends StatelessWidget {
  const PinnedMessageEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.images.imgPinnedEmpty.image(width: 160, height: 160),
          SizedBox(height: 10),
          Text(
            "pinned_message_list.content".tr(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              height: 28 / 24,
              fontFamily: FontFamily.segoeUI,
              color: AppColors.textDefaultTextDefault,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "pinned_message_list.description".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              height: 28 / 16,
              fontFamily: FontFamily.segoeUI,
              color: AppColors.textDefaultTextSub2,
            ),
          ),
        ],
      ),
    );
  }
}
