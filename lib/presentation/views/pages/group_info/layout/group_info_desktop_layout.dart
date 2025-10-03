import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain/entities/workspace_entity.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';
import '../../../../routers/app_router.dart';
import '../../../widgets/circle_network_avatar.dart';
import '../bloc/group_info_bloc.dart';
import '../widgets/group_info_card_widget.dart';

class GroupInfoDesktopLayout extends StatelessWidget {
  const GroupInfoDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GroupInfoBloc>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerPrimaryPrimaryDefault,
        elevation: 0,
        toolbarHeight: 60,
        title: Text(
          'group_info.title'.tr(),
          style: TextStyle(
            color: AppColors.textDefaultTextInverted,
            fontSize: 22,
            fontFamily: FontFamily.segoeUI,
            fontWeight: FontWeight.w700,
            height: 1.27,
          ),
        ),
        centerTitle: true,
        leadingWidth: 52,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.outlineGrayStrong200, height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildHeaderInfo(context),
              SizedBox(height: 20),
              _buildBody(context, bloc),
              SizedBox(height: 12),
              _buildLeaveGroupButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: double.infinity),
        _buildAvatar(context),
        SizedBox(height: 16),
        _buildGroupName(context),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            //todo
          },
          child: BlocSelector<GroupInfoBloc, GroupInfoState, WorkspaceEntity?>(
            selector: (state) {
              return state.workspace;
            },
            builder: (context, state) {
              return CircleNetworkAvatar(
                size: 80,
                imageUrl: state?.workspaceAvatar ?? "",
              );
            },
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: () {
              context.router.push(CameraRoute());
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Assets.icons.icCamera.svg(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupName(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final group = context.read<GroupInfoBloc>().state.workspace;
        final name = group?.workspaceName ?? "";
        final id = group?.id ?? 0;
        context.router.push(
          EditWorkspaceNameRoute(name: name, workspaceId: id),
        );
      },
      child: BlocSelector<GroupInfoBloc, GroupInfoState, WorkspaceEntity?>(
        selector: (state) {
          return state.workspace;
        },
        builder: (context, state) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  state?.workspaceName ?? "",
                  style: TextStyle(
                    fontFamily: FontFamily.segoeUI,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    height: 26 / 20,
                    color: AppColors.textDefaultTextDefault,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Assets.icons.icEditSize18.svg(
                colorFilter: const ColorFilter.mode(
                  AppColors.iconDefaultDefault,
                  BlendMode.srcIn,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, GroupInfoBloc bloc) {
    return Column(
      children: [
        BlocSelector<GroupInfoBloc, GroupInfoState, WorkspaceEntity?>(
          selector: (state) {
            return state.workspace;
          },
          builder: (_, state) {
            return GroupInfoCardWidget(
              items: [
                GroupInfoItem(
                  icon: Assets.icons.icBio.svg(
                    colorFilter: ColorFilter.mode(
                      AppColors.iconPrimaryDefault,
                      BlendMode.srcIn,
                    ),
                  ),
                  title: "group_info.bio".tr(),
                  trailing: RotatedBox(
                    quarterTurns: 2,
                    child: Assets.icons.icArrowLeft.svg(
                      colorFilter: ColorFilter.mode(
                        AppColors.iconDefaultDefaultSub2,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  description: state?.bio,
                  onTap: () async {
                    final workspace = state;
                    if (workspace == null) return;
                    final result = await context.router.push(
                      EditWorkspaceBioRoute(
                        bio: workspace.bio ?? "",
                        workspaceId: workspace.id,
                      ),
                    );

                    if (result == null) return;
                    bloc.add(UpdateWorkspaceEvent(bio: result as String));
                  },
                ),
              ],
            );
          },
        ),

        SizedBox(height: 12),
        BlocSelector<GroupInfoBloc, GroupInfoState, WorkspaceEntity?>(
          selector: (state) {
            return state.workspace;
          },
          builder: (context, state) {
            return GroupInfoCardWidget(
              items: [
                GroupInfoItem(
                  icon: Assets.icons.icSearch.svg(
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      AppColors.iconPrimaryDefault,
                      BlendMode.srcIn,
                    ),
                  ),
                  title: "group_info.search_in_conversation".tr(),
                  onTap: () {
                    final workspace = context
                        .read<GroupInfoBloc>()
                        .state
                        .workspace;
                    if (workspace == null) return;
                    context.router.push(
                      WSDetailRoute(
                        groupId: workspace.id,
                        groupName: workspace.workspaceName,
                        groupAvatar: workspace.workspaceAvatar,
                        isSearchMode: true,
                      ),
                    );
                  },
                ),
                GroupInfoItem(
                  icon: Assets.icons.icMembers.svg(
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      AppColors.iconPrimaryDefault,
                      BlendMode.srcIn,
                    ),
                  ),
                  trailing: RotatedBox(
                    quarterTurns: 2,
                    child: Assets.icons.icArrowLeft.svg(
                      colorFilter: ColorFilter.mode(
                        AppColors.iconDefaultDefaultSub2,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  title: "group_info.member".tr(),
                  info: ((state?.countMember ?? 0) > 0)
                      ? "${state?.countMember}"
                      : null,
                  onTap: () {
                    if (state == null) return;
                    context.router.push(MembersRoute(workspaceId: state.id));
                  },
                ),
              ],
            );
          },
        ),
        SizedBox(height: 12),

        BlocSelector<GroupInfoBloc, GroupInfoState, WorkspaceEntity?>(
          selector: (state) {
            return state.workspace;
          },
          builder: (context, state) {
            return GroupInfoCardWidget(
              items: [
                GroupInfoItem(
                  icon: Assets.icons.icAlbum.svg(
                    colorFilter: ColorFilter.mode(
                      AppColors.iconPrimaryDefault,
                      BlendMode.srcIn,
                    ),
                  ),
                  trailing: RotatedBox(
                    quarterTurns: 2,
                    child: Assets.icons.icArrowLeft.svg(
                      colorFilter: ColorFilter.mode(
                        AppColors.iconDefaultDefaultSub2,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  title: "group_info.media_file".tr(),
                  onTap: () {
                    if (state == null) return;
                    context.router.push(
                      WorkspaceAttachmentRoute(workspaceId: state.id),
                    );
                  },
                ),
                GroupInfoItem(
                  icon: Assets.icons.icPin.svg(
                    colorFilter: ColorFilter.mode(
                      AppColors.iconPrimaryDefault,
                      BlendMode.srcIn,
                    ),
                  ),
                  title: "group_info.pin_message".tr(),
                  info: ((state?.countPin ?? 0) > 0)
                      ? "${state?.countPin}"
                      : null,
                  trailing: RotatedBox(
                    quarterTurns: 2,
                    child: Assets.icons.icArrowLeft.svg(
                      colorFilter: ColorFilter.mode(
                        AppColors.iconDefaultDefaultSub2,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  onTap: () {
                    final group = bloc.state.workspace;
                    if (group == null) return;
                    context.router.push(
                      PinnedMessageListRoute(
                        groupId: 5,
                        groupName: group.workspaceName,
                        groupAvatar: group.workspaceAvatar,
                      ),
                    );
                  },
                ),
                GroupInfoItem(
                  icon: Assets.icons.icBlockNotification.svg(
                    colorFilter: ColorFilter.mode(
                      AppColors.iconPrimaryDefault,
                      BlendMode.srcIn,
                    ),
                  ),
                  title: "group_info.mute_notification".tr(),
                  trailing:
                      BlocSelector<
                        GroupInfoBloc,
                        GroupInfoState,
                        WorkspaceEntity?
                      >(
                        selector: (state) => state.workspace,
                        builder: (context, workspace) {
                          return SizedBox(
                            width: 51,
                            height: 31,
                            child: CupertinoSwitch(
                              value: workspace?.isMute ?? false,
                              onChanged: (_) {
                                bloc.add(ToggleNotificationEvent());
                              },
                            ),
                          );
                        },
                      ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildLeaveGroupButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerAlertErrorLight,
          border: Border.all(color: AppColors.outlineAlertErrorLight, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          height: 32,
          child: Row(
            children: [
              Assets.icons.icLogout.svg(width: 32, height: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'group_info.leave_group'.tr(),
                  style: TextStyle(
                    color: AppColors.textAlertTextError,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
