import 'package:auto_route/auto_route.dart';
import 'package:dartx/dartx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/models/group_info_arguments.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';
import 'package:ig_agency_app/presentation/views/pages/group_info/widgets/group_info_card_widget.dart';
import 'package:ig_agency_app/presentation/views/widgets/circle_network_avatar.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../dependencies/media/media_manager.dart';
import '../../../../../di/di.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../../shared/commons/enums/media_use_case.dart';
import '../../../../resources/colors.dart';
import '../../../modal/select_image_modal.dart';
import '../bloc/group_info_bloc.dart';

class GroupInfoMobileLayout extends StatefulWidget {
  const GroupInfoMobileLayout({super.key});

  @override
  State<GroupInfoMobileLayout> createState() => _GroupInfoMobileLayoutState();
}

class _GroupInfoMobileLayoutState extends State<GroupInfoMobileLayout> {
  late GroupInfoBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<GroupInfoBloc>();
  }

  void _onChangeAvatar(BuildContext context) async {
    final imageSource = await SelectImageModal.show(context);
    String? path;
    if (!context.mounted) return;
    if (imageSource == ImageSource.camera) {
      path = await context.router.push(
        CameraRoute(mediaUseCase: MediaUseCase.updateAvatar),
      );
    } else if (imageSource == ImageSource.gallery) {
      final file = await getIt<MediaManager>().pickPhoto();
      if ((file?.path).isNotNullOrEmpty && context.mounted) {
        path = await context.router.push(
          MediaPreviewRoute(
            mediaPath: file?.path ?? '',
            mediaUseCase: MediaUseCase.updateAvatar,
          ),
        );
      }
    }

    if (path.isNotNullOrEmpty && context.mounted) {
      _bloc.add(UpdateAvatarEvent(path ?? ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GroupInfoBloc>();
    return BlocListener<GroupInfoBloc, GroupInfoState>(
      listenWhen: (prev, curr) =>
          prev.isLeaveGroupSuccess != curr.isLeaveGroupSuccess,
      listener: (context, state) {
        if (state.isLeaveGroupSuccess == true) {
          context.router.pop();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildHeaderInfo(context),
                SizedBox(height: 20),
                _buildBody(context, bloc),
                SizedBox(height: 12),
                _buildLeaveGroupButton(bloc),
              ],
            ),
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
          onTap: () {},
          child: BlocSelector<GroupInfoBloc, GroupInfoState, String>(
            selector: (state) => state.avatar,
            builder: (context, groupAvatar) {
              return CircleNetworkAvatar(
                size: 80,
                imageUrl: groupAvatar,
                isGroupAvt: true,
              );
            },
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: () {
              _onChangeAvatar(context);
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
      onTap: () async {
        final bloc = context.read<GroupInfoBloc>();
        final name = bloc.state.name;
        final result = await context.router.push(
          EditGroupNameRoute(name: name, workspaceId: bloc.groupId),
        );
        if (result is! String) return;
        bloc.add(UpdateNameEvent(result));
      },
      child: BlocSelector<GroupInfoBloc, GroupInfoState, String>(
        selector: (state) => state.name,
        builder: (context, groupName) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  groupName,
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
        BlocSelector<GroupInfoBloc, GroupInfoState, String?>(
          selector: (state) => state.bio,
          builder: (_, bio) {
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
                  description: bio,
                  onTap: () async {
                    final result = await context.router.push(
                      EditGroupBioRoute(
                        bio: bio ?? '',
                        workspaceId: _bloc.groupId,
                      ),
                    );
                    if (result is! String) return;
                    bloc.add(UpdateBioEvent(result));
                  },
                ),
              ],
            );
          },
        ),

        SizedBox(height: 12),
        GroupInfoCardWidget(
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
              onTap: () async {
                final state = _bloc.state;
                final name = await context.router.push(
                  WSDetailRoute(
                    groupId: _bloc.groupId,
                    groupName: state.name,
                    groupAvatar: state.avatar,
                    isSearchMode: true,
                  ),
                );
                if (name is! String) return;
                _bloc.add(UpdateNameEvent(name));
              },
            ),
            BlocSelector<GroupInfoBloc, GroupInfoState, int>(
              builder: (context, memberCount) {
                return GroupInfoItem(
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
                  info: (memberCount > 0) ? "$memberCount" : null,
                  onTap: () {
                    context.router.push(
                      MembersRoute(workspaceId: _bloc.groupId),
                    );
                  },
                );
              },
              selector: (state) => state.memberCount,
            ),
          ],
        ),
        SizedBox(height: 12),

        GroupInfoCardWidget(
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
                context.router.push(
                  WorkspaceAttachmentRoute(workspaceId: _bloc.groupId),
                );
              },
            ),
            BlocSelector<GroupInfoBloc, GroupInfoState, int?>(
              selector: (state) => state.pinnedMessageCount,
              builder: (context, countPin) {
                return GroupInfoItem(
                  icon: Assets.icons.icPin.svg(
                    colorFilter: ColorFilter.mode(
                      AppColors.iconPrimaryDefault,
                      BlendMode.srcIn,
                    ),
                  ),
                  title: "group_info.pin_message".tr(),
                  info: ((countPin ?? 0) > 0) ? "$countPin" : null,
                  trailing: RotatedBox(
                    quarterTurns: 2,
                    child: Assets.icons.icArrowLeft.svg(
                      colorFilter: ColorFilter.mode(
                        AppColors.iconDefaultDefaultSub2,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  onTap: () async {
                    final messageId = await context.router.push(
                      PinnedMessageListRoute(groupId: bloc.groupId),
                    );
                    if (messageId != null &&
                        context.mounted &&
                        messageId is String) {
                      context.router.pop(
                        GroupInfoArguments(messageId: messageId),
                      );
                    }
                  },
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
              trailing: BlocSelector<GroupInfoBloc, GroupInfoState, bool>(
                selector: (state) => state.isMute,
                builder: (context, isMute) {
                  return SizedBox(
                    width: 51,
                    height: 31,
                    child: CupertinoSwitch(
                      value: isMute,
                      onChanged: (_) {
                        bloc.add(ToggleNotificationEvent());
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLeaveGroupButton(GroupInfoBloc bloc) {
    return GestureDetector(
      onTap: () {
        bloc.add(LeaveGroupEvent());
      },
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
