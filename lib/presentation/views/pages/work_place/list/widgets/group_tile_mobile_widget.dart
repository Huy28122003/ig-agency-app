import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/views/widgets/circle_network_avatar.dart';
import 'package:ig_agency_app/shared/extensions/date_time_extension.dart';
import '../../../../../../gen/assets.gen.dart';

class GroupTileMobileWidget extends StatelessWidget {
  const GroupTileMobileWidget({
    super.key,
    required this.workspaceAvatar,
    required this.workspaceName,
    required this.lastMessage,
    this.lastMessageTime,
    required this.isSeen,
    required this.isMute,
    required this.isPin,
    // required this.countNewMessage,
    required this.onTap,
    this.isSearchMode = false,
    this.unreadCount = 0,
  });

  final String workspaceAvatar;
  final String workspaceName;
  final String lastMessage;
  final DateTime? lastMessageTime;
  final bool isSeen;
  final bool isMute;
  final bool isPin;
  final int unreadCount;

  // final int countNewMessage;
  final bool isSearchMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.only(left: 20, top: 8, right: 12),
        child: isSearchMode ? _buildSearchMode() : _buildNormalMode(),
      ),
    );
  }

  Widget _buildSearchMode() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatar(),
            const SizedBox(width: 8),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  workspaceName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    height: 26 / 18,
                    color: AppColors.textDefaultTextDefault,
                    fontFamily: FontFamily.segoeUI,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildDivider(),
      ],
    );
  }

  Widget _buildNormalMode() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              workspaceName,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                height: 26 / 18,
                                color: AppColors.textDefaultTextDefault,
                                fontFamily: FontFamily.segoeUI,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (lastMessage.isNotEmpty)
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      (unreadCount > 1 && !isSeen)
                                          ? "$unreadCount ${'workspace.new_message'.tr()}"
                                          : lastMessage,
                                      // lastMessage,
                                      style: TextStyle(
                                        fontFamily: FontFamily.segoeUI,
                                        fontSize: 14,
                                        height: 20 / 14,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: isSeen
                                            ? FontWeight.w400
                                            : FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),

                                  const SizedBox(width: 4),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.textDefaultTextSub2,
                                    ),
                                    width: 4,
                                    height: 4,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    lastMessageTime
                                            ?.convertDateTimeToString() ??
                                        '',
                                    style: TextStyle(
                                      fontFamily: FontFamily.segoeUI,
                                      fontSize: 14,
                                      height: 20 / 14,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (isPin) Assets.icons.icPin.svg(),
                      if (!isMute) Assets.icons.icBlockNotification.svg(),
                      if (!isSeen)
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.iconPrimaryDefault,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildDivider(),
      ],
    );
  }

  Widget _buildAvatar() {
    return CircleNetworkAvatar(imageUrl: workspaceAvatar, isGroupAvt: true);
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.only(left: 44 + 8),
      width: double.infinity,
      height: 1,
      color: AppColors.outlineGrayStrong200,
    );
  }
}
