import 'package:flutter/material.dart';

import '../../../shared/commons/app_checkbox.dart';
import '../../resources/colors.dart';
import 'circle_network_avatar.dart';

class AvatarTitleCheckboxRow extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final bool? isSelected;
  final VoidCallback? onTap;

  const AvatarTitleCheckboxRow({
    this.imageUrl,
    this.title,
    this.isSelected,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                CircleNetworkAvatar(imageUrl: imageUrl ?? '', size: 48),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textDefaultTextDefault,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                AppCheckBox(
                  value: isSelected ?? false,
                  onChanged: (value) {
                    onTap?.call();
                  },
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 56),
            child: Divider(height: 1, color: Color(0xFFE5E7EB)),
          ),
        ],
      ),
    );
  }
}
