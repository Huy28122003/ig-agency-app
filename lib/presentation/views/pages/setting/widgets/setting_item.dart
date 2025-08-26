import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';

import '../../../../../../gen/assets.gen.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.isShowArrow = false,
  });

  final Widget icon;
  final String title;
  final Widget? trailing;
  final bool isShowArrow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 32,
          child: Row(
            children: [
              icon,
              const SizedBox(width: 12),
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
      ),
    );
  }
}
