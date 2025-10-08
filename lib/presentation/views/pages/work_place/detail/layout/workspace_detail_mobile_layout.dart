import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_search_text_field.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../../../domain/entities/user_entity.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../../shared/commons/enums/group_chat_status.dart';
import '../../../../../resources/colors.dart';
import '../../../../../routers/app_router.dart';
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
        appBar: _WorkspaceAppBar(
          groupAvatar: widget.groupAvatar,
          groupName: widget.groupName,
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
                      screenType: DeviceScreenType.mobile,
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

class _WorkspaceAppBar extends StatefulWidget implements PreferredSizeWidget {
  const _WorkspaceAppBar({required this.groupName, required this.groupAvatar});

  final String groupName;
  final String groupAvatar;

  @override
  State<_WorkspaceAppBar> createState() => _WorkspaceAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _WorkspaceAppBarState extends State<_WorkspaceAppBar> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<WSDetailBloc, WSDetailState, bool>(
      selector: (state) => state.isSearchMode,
      builder: (context, isSearching) {
        return isSearching
            ? _buildAppBarSearchMode(context)
            : _buildAppBarNormal(context);
      },
    );
  }

  AppBar _buildAppBarNormal(BuildContext context) {
    return AppBar(
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
      title: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          final messageId = await context.router.push(
            GroupInfoRoute(groupId: context.read<WSDetailBloc>().groupId),
          );
          if (messageId != null && messageId is String && context.mounted) {
            context.read<WSDetailBloc>().add(
              JumpToMessageEvent(messageId: messageId),
            );
          }
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
    );
  }

  PreferredSizeWidget _buildAppBarSearchMode(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Row(
          children: [
            SizedBox(width: 12),
            Expanded(
              child: BlocSelector<WSDetailBloc, WSDetailState, String>(
                selector: (state) {
                  return state.searchKeyword;
                },
                builder: (context, state) {
                  return AppSearchTextField(
                    value: state,
                    contentPadding: EdgeInsets.only(
                      left: 16,
                      top: 8,
                      bottom: 8,
                    ),
                    fillColor: AppColors.surfaceContainerGrayStrong2,
                    hintText: "search.search_in_conversation".tr(),
                    hintStyle: TextStyle(
                      fontSize: 16,
                      height: 24 / 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDefaultTextSub2,
                      fontFamily: FontFamily.segoeUI,
                    ),
                    onChanged: (value) {
                      context.read<WSDetailBloc>().add(
                        SearchKeywordChangeEvent(value: value),
                      );
                      context.read<WSDetailBloc>().add(SearchMessageEvent());
                    },
                  );
                },
              ),
            ),
            SizedBox(width: 10),
            TextButton(
              onPressed: () {
                context.read<WSDetailBloc>().add(CancelSearchEvent());
              },
              child: Text(
                "general.cancel".tr(),
                style: TextStyle(
                  color: AppColors.iconAlertInfo,
                  fontFamily: FontFamily.segoeUI,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 24 / 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
