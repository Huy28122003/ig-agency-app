import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/views/widgets/circle_network_avatar.dart';
import 'package:ig_agency_app/shared/extensions/date_time_extension.dart';
import '../../../../../../gen/assets.gen.dart';

class WorkspaceTileMobileWidget extends StatefulWidget {
  const WorkspaceTileMobileWidget({
    super.key,
    required this.workspaceAvatar,
    required this.workspaceName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isSeen,
    required this.isMute,
    required this.isPin,
    required this.countNewMessage,
    required this.onTap,
    this.isSearchMode = false,
  });

  final String workspaceAvatar;
  final String workspaceName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool isSeen;
  final bool isMute;
  final bool isPin;
  final int countNewMessage;
  final bool isSearchMode;
  final VoidCallback onTap;

  @override
  State<WorkspaceTileMobileWidget> createState() =>
      _WorkspaceTileMobileWidgetState();
}

class _WorkspaceTileMobileWidgetState extends State<WorkspaceTileMobileWidget> {
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 20, top: 8, right: 12),
        child: widget.isSearchMode ? _buildSearchMode() : _buildNormalMode(),
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
                  widget.workspaceName,
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
                              widget.workspaceName,
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
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    (widget.countNewMessage > 1 &&
                                            !widget.isSeen)
                                        ? "${widget.countNewMessage} ${'workspace.new_message'.tr()}"
                                        : widget.lastMessage,
                                    style: TextStyle(
                                      fontFamily: FontFamily.segoeUI,
                                      fontSize: 14,
                                      height: 20 / 14,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: widget.isSeen
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
                                  _convertDateTimeToString(),
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
                      if (widget.isPin) Assets.icons.icPin.svg(),
                      if (!widget.isMute)
                        Assets.icons.icBlockNotification.svg(),
                      if (!widget.isSeen)
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
    return CircleNetworkAvatar(
      imageUrl: widget.workspaceAvatar,
      isGroupAvt: true,
    );
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 1,
      color: AppColors.outlineGrayStrong200,
    );
  }

  String _convertDateTimeToString() {
    final isToday =
        now.year == widget.lastMessageTime.year &&
        now.month == widget.lastMessageTime.month &&
        now.day == widget.lastMessageTime.day;
    if (isToday) {
      return widget.lastMessageTime.toHourMinuteAmPm;
    } else {
      return widget.lastMessageTime.toRelativeString;
    }
  }
}
