import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';

import 'setting_item.dart';

class SettingCard extends StatelessWidget {
  const SettingCard({super.key, required this.items});

  final List<SettingItem> items;

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
