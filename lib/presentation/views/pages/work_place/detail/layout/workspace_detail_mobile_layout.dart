import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../domain/entities/user_entity.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../../shared/commons/enums/group_chat_status.dart';
import '../../../../../resources/colors.dart';
import '../../../../widgets/circle_network_avatar.dart';
import '../widgets/group_chat_view.dart';
import '../widgets/group_removed_view.dart';
import '../workspace_detail_bloc.dart';

class WorkspaceDetailMobileLayout extends StatefulWidget {
  const WorkspaceDetailMobileLayout({
    super.key,
    required this.groupName,
    required this.groupAvatar,
  });

  final String groupName;
  final String groupAvatar;

  @override
  State<WorkspaceDetailMobileLayout> createState() =>
      _WorkspaceDetailMobileLayoutState();
}

class _WorkspaceDetailMobileLayoutState
    extends State<WorkspaceDetailMobileLayout> {
  late final WSDetailBloc _bloc;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _bloc = context.read<WSDetailBloc>();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_bloc.state.groupMemberStatus == GroupMemberStatus.removed) {
          return;
        }
        _bloc.textEditingController.closeTagOverlay();
        if (!_bloc.state.showTagOverlay) {
          _focusNode.unfocus();
          _bloc.add(ToggleHasOptionsEvent(showOptions: true));
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 44,
          toolbarHeight: 60,
          scrolledUnderElevation: 0,
          leading: GestureDetector(
            onTap: () => context.router.pop(),
            child: Stack(
              children: [
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    height: 24,
                    width: 24,
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => context.router.pop(),
                      child: Assets.icons.icArrowLeft.svg(
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          AppColors.iconDefaultDefault,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    height: 18,
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.iconAlertInfo,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '29',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          titleSpacing: 12,
          title: Row(
            children: [
              CircleNetworkAvatar(imageUrl: widget.groupAvatar, size: 40),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.groupName,
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
                    BlocSelector<WSDetailBloc, WSDetailState, List<UserEntity>>(
                      selector: (state) {
                        return state.users;
                      },
                      builder: (context, users) {
                        final onlineUsers = users
                            .where((user) => user.isOnline)
                            .length;
                        return Text(
                          '${users.length} ${users.length == 1 ? 'Member' : 'Members'}, $onlineUsers Online',
                          style: TextStyle(
                            color: AppColors.textDefaultTextSub2,
                            fontSize: 14,
                            fontFamily: FontFamily.segoeUI,
                            fontWeight: FontWeight.w400,
                            height: 1.14,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: BlocSelector<WSDetailBloc, WSDetailState, GroupMemberStatus>(
          selector: (state) {
            return state.groupMemberStatus;
          },
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 1200),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: state == GroupMemberStatus.joined
                  ? GroupChatView(
                      key: const ValueKey('group_chat'),
                      bloc: _bloc,
                      focusNode: _focusNode,
                      isMobile: true,
                    )
                  : GroupRemovedView(
                      key: const ValueKey('group_removed'),
                      bloc: _bloc,
                      isMobile: true,
                    ),
            );
          },
        ),
      ),
    );
  }
}
