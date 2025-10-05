import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/presentation/views/pages/work_place/detail/workspace_detail_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../../../gen/fonts.gen.dart';
import '../../../../../../shared/commons/enums/group_chat_status.dart';
import '../../../../../resources/colors.dart';
import '../../../../../routers/app_router.dart';
import '../../../../widgets/circle_network_avatar.dart';

import '../widgets/group_chat_view.dart';
import '../widgets/group_removed_view.dart';

class WorkspaceDetailTabletLayout extends StatefulWidget {
  const WorkspaceDetailTabletLayout({
    super.key,
    required this.groupName,
    required this.groupAvatar,
  });

  final String groupName;
  final String groupAvatar;

  @override
  State<WorkspaceDetailTabletLayout> createState() =>
      _WorkspaceDetailTabletLayoutState();
}

class _WorkspaceDetailTabletLayoutState
    extends State<WorkspaceDetailTabletLayout> {
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
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                context.router.push(
                  GroupInfoRoute(
                    groupId: context.read<WSDetailBloc>().groupId,
                  ),
                );
              },
              child: Row(
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
                        BlocSelector<
                          WSDetailBloc,
                          WSDetailState,
                          List<UserEntity>
                        >(
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
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: AppColors.outlineGrayStrong200,
              height: 1,
            ),
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
                      groupName: widget.groupName,
                      screenType: DeviceScreenType.tablet,
                    )
                  : GroupRemovedView(
                      key: const ValueKey('group_removed'),
                      bloc: _bloc,
                    ),
            );
          },
        ),
      ),
    );
  }
}
