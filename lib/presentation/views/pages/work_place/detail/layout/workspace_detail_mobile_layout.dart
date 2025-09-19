import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../domain/entities/message/message.dart';
import '../../../../../../domain/entities/user_entity.dart';
import '../../../../../../domain/enums/send_message_type.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../../shared/commons/enums/group_chat_status.dart';
import '../../../../../resources/colors.dart';
import '../../../../../routers/app_router.dart';
import '../../../../ui_models/pinned_message_summary_ui_model.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/chat/pinned_message_section.dart';
import '../../../../widgets/chat_bubble/chat_message_bubble.dart';
import '../../../../widgets/circle_network_avatar.dart';
import '../../../../widgets/chat_input/chat_input_bar.dart';
import '../../../../widgets/chat_input/tag_user_list_view.dart';
import '../widgets/chat_content.dart';
import '../../../../modal/pinned_message/pinned_message_bottom_sheet.dart';
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
            return state == GroupMemberStatus.joined
                ? _GroupChatView(bloc: _bloc, focusNode: _focusNode)
                : _GroupRemovedView(bloc: _bloc);
          },
        ),
      ),
    );
  }
}

class _GroupChatView extends StatelessWidget {
  const _GroupChatView({required this.bloc, required this.focusNode});

  final WSDetailBloc bloc;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Column(
                children: [
                  BlocSelector<
                    WSDetailBloc,
                    WSDetailState,
                    PinnedMessageSummaryUiModel?
                  >(
                    selector: (state) {
                      return state.pinnedMessageSummary;
                    },
                    builder: (context, pinnedMessageSummary) {
                      if (pinnedMessageSummary == null) {
                        return const SizedBox.shrink();
                      }

                      return SizedBox(
                        child: PinnedMessageSection(
                          pinnedMessageSummary: pinnedMessageSummary,
                          onTap: () {
                            PinnedMessagesBottomSheet.show(
                              context,
                              bloc.groupId,
                              onUnpinSuccess: () {
                                bloc.add(GetPinnedMessageSummaryEvent());
                              },
                              onTap: (messageId) {
                                bloc.add(
                                  JumpToMessageEvent(messageId: messageId),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Expanded(child: ChatContent()),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BlocBuilder<WSDetailBloc, WSDetailState>(
                  buildWhen: (previous, current) =>
                      previous.usersSearch != current.usersSearch ||
                      previous.showTagOverlay != current.showTagOverlay,
                  builder: (context, state) {
                    if (state.usersSearch.isEmpty || !state.showTagOverlay) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TagUserListView(
                        users: state.usersSearch,
                        onTap: (user) {
                          bloc.textEditingController.addTag(user.name, user.id);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        BlocSelector<WSDetailBloc, WSDetailState, MessageEntity?>(
          selector: (state) {
            return state.messageReply;
          },
          builder: (context, message) {
            return ChatInputBar(
              userId: bloc.userId,
              focusNode: focusNode,
              textEditingController: bloc.textEditingController,
              messageReply: message,
              onReplyClose: () {
                bloc.add(CloseReplyMessageEvent());
              },
              onDocumentTap: () {
                bloc.add(SendMessageEvent(type: SendMessageType.file));
              },
              onCameraTap: () {
                context.router.push(CameraRoute());
              },
              onMediaTap: () {
                bloc.add(SendMessageEvent(type: SendMessageType.media));
              },
              onSendTap: () {
                bloc.add(SendMessageEvent(type: SendMessageType.text));
              },
              onToggleOptions: (showOptions) {
                bloc.add(ToggleHasOptionsEvent(showOptions: showOptions));
              },
            );
          },
        ),
      ],
    );
  }
}

class _GroupRemovedView extends StatelessWidget {
  const _GroupRemovedView({required WSDetailBloc bloc}) : _bloc = bloc;

  final WSDetailBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return BlocListener<WSDetailBloc, WSDetailState>(
      listenWhen: (previous, current) =>
          previous.isDeletedConversationSuccess !=
          current.isDeletedConversationSuccess,
      listener: (context, state) {
        if (state.isDeletedConversationSuccess) {
          context.router.pop();
        }
      },
      child: SafeArea(
        child: Column(
          spacing: 20,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: BlocBuilder<WSDetailBloc, WSDetailState>(
                  buildWhen: (previous, current) =>
                      previous.chatMessages != current.chatMessages,
                  builder: (context, state) {
                    return state.chatMessages.isEmpty
                        ? const SizedBox.shrink()
                        : ChatMessageBubble.system(
                            message: state.chatMessages.first.message,
                            shouldShowTime: true,
                          );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: AppColors.outlineGrayStrong200,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 12,
                children: [
                  _buildContent(),
                  AppButton.primary(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: AppColors.surfaceContainerAlertError,
                    onPressed: () {
                      _bloc.add(DeleteConversationEvent());
                    },
                    child: Text(
                      'Delete conversation',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textDefaultTextInverted,
                        fontSize: 16,
                        fontFamily: FontFamily.segoeUI,
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'You can’t message this group',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textAlertTextError,
            fontSize: 13,
            fontFamily: FontFamily.segoeUI,
            fontWeight: FontWeight.w600,
            height: 1.23,
          ),
        ),
        Text(
          'You’re no longer in this group and can’t send or receive calls or messages unless you are added back to it.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textDefaultTextSub2,
            fontSize: 12,
            fontFamily: FontFamily.segoeUI,
            fontWeight: FontWeight.w400,
            height: 1.33,
          ),
        ),
      ],
    );
  }
}
