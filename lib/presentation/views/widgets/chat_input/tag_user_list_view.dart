import 'package:flutter/material.dart';

import '../../../../domain/entities/user_entity.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../resources/colors.dart';
import '../circle_network_avatar.dart';

class TagUserListView extends StatelessWidget {
  const TagUserListView({super.key, required this.onTap, required this.users});
  final Function(UserEntity) onTap;
  final List<UserEntity> users;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 252),
      padding: const EdgeInsets.symmetric(vertical: 4),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: AppColors.surfaceContainerGrayStrong0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadows: [
          BoxShadow(
            color: Color(0x1E000000),
            blurRadius: 40,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: users.length,
        itemBuilder: (context, index) =>
            _TagUserItem(user: users[index], onTap: () => onTap(users[index])),
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: AppColors.outlineGrayStrong200),
      ),
    );
  }
}

class _TagUserItem extends StatelessWidget {
  const _TagUserItem({required this.user, required this.onTap});

  final UserEntity user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 64,
        padding: const EdgeInsets.only(
          left: 12,
          right: 24,
          top: 12,
          bottom: 12,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            CircleNetworkAvatar(imageUrl: user.avatar, size: 40),
            Expanded(
              child: Text(
                user.name,
                style: TextStyle(
                  color: AppColors.textDefaultTextDefault,
                  fontSize: 16,
                  fontFamily: FontFamily.segoeUI,
                  fontWeight: FontWeight.w700,
                  height: 1.50,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
