import 'package:flutter/material.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import '../../../../../gen/assets.gen.dart';

class GroupInfoCardWidget extends StatelessWidget {
  const GroupInfoCardWidget({super.key, required this.items});

  final List<GroupInfoItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: ShapeDecoration(
        color: AppColors.surfaceContainerGrayStrong05,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.outlineGrayStrong200),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            items[i],
            if (i < items.length - 1)
              const Divider(
                height: 1,
                indent: 54,
                endIndent: 16,
                color: AppColors.outlineGrayStrong200,
              ),
          ],
        ],
      ),
    );
  }
}

class GroupInfoItem extends StatelessWidget {
  const GroupInfoItem({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.isShowArrow = false,
    this.description,
    this.info,
  });

  final Widget icon;
  final String title;
  final Widget? trailing;
  final bool isShowArrow;
  final VoidCallback? onTap;
  final String? description;
  final String? info;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(16),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: AppColors.textDefaultTextDefault,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.50,
                          ),
                        ),
                      ),
                      if (info != null) ...[
                        SizedBox(width: 13),
                        Text(
                          info!,
                          style: TextStyle(
                            color: AppColors.textDefaultTextDefault,
                            fontSize: 14,
                            height: 20 / 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: FontFamily.segoeUI,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (description != null)
                    Text(
                      textAlign: TextAlign.start,
                      description!,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: FontFamily.segoeUI,
                        height: 20 / 14,
                        color: AppColors.textDefaultTextSub2,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ] else if (isShowArrow) ...[
              const SizedBox(width: 8),
              Assets.icons.icNext.svg(
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  AppColors.iconDefaultDefault,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
