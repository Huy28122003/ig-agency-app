import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_search_text_field.dart';

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
                  ? _GroupChatView(
                      key: const ValueKey('group_chat'),
                      bloc: _bloc,
                      focusNode: _focusNode,
                      groupName: widget.groupName,
                    )
                  : _GroupRemovedView(
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
        onTap: () {
          context.router.push(
            GroupInfoRoute(groupId: context.read<WSDetailBloc>().groupId),
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

class _GroupChatView extends StatelessWidget {
  const _GroupChatView({
    super.key,
    required this.bloc,
    required this.focusNode,
    required this.groupName,
  });

  final WSDetailBloc bloc;
  final FocusNode focusNode;
  final String groupName;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WSDetailBloc, WSDetailState, bool>(
      selector: (state) {
        return state.isSearchMode;
      },
      builder: (context, state) {
        return Stack(
          children: [
            Column(
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
                                        bloc.add(
                                          GetPinnedMessageSummaryEvent(),
                                        );
                                      },
                                      onTap: (messageId) {
                                        bloc.add(
                                          JumpToMessageEvent(
                                            messageId: messageId,
                                          ),
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
                            if (state.usersSearch.isEmpty ||
                                !state.showTagOverlay) {
                              return const SizedBox.shrink();
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: TagUserListView(
                                users: state.usersSearch,
                                onTap: (user) {
                                  bloc.textEditingController.addTag(
                                    user.name,
                                    user.id,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                BlocSelector<WSDetailBloc, WSDetailState, bool>(
                  selector: (state) {
                    return state.isSearchMode;
                  },
                  builder: (context, state) {
                    if (state) {
                      return SizedBox(height: 44);
                    }
                    return BlocSelector<
                      WSDetailBloc,
                      WSDetailState,
                      MessageEntity?
                    >(
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
                            bloc.add(
                              SendMessageEvent(type: SendMessageType.file),
                            );
                          },
                          onCameraTap: () {
                            context.router.push(CameraRoute());
                          },
                          onMediaTap: () {
                            bloc.add(
                              SendMessageEvent(type: SendMessageType.media),
                            );
                          },
                          onSendTap: () {
                            bloc.add(
                              SendMessageEvent(type: SendMessageType.text),
                            );
                          },
                          onToggleOptions: (showOptions) {
                            bloc.add(
                              ToggleHasOptionsEvent(showOptions: showOptions),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            if (state)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SearchResultsBar(groupName: groupName),
              ),
          ],
        );
      },
    );
  }
}

class SearchResultsBar extends StatelessWidget {
  const SearchResultsBar({super.key, required this.groupName});

  final String groupName;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<WSDetailBloc>();
    return BlocBuilder<WSDetailBloc, WSDetailState>(
      buildWhen: (prev, curr) =>
          prev.indexSearchMessage != curr.indexSearchMessage ||
          prev.messageSearchResults != curr.messageSearchResults,
      builder: (context, state) {
        final goToUpEnable =
            state.indexSearchMessage <
                bloc.state.messageSearchResults.length - 1 &&
            bloc.state.messageSearchResults.length > 1;
        final goToDownEnable =
            state.indexSearchMessage > 0 &&
            bloc.state.messageSearchResults.length > 1;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BlocSelector<WSDetailBloc, WSDetailState, List<MessageEntity>>(
              selector: (state) {
                return state.messageSearchResults;
              },
              builder: (context, state) {
                if (state.length < 2) {
                  return SizedBox();
                }
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!goToUpEnable) return;
                        bloc.add(GoToMessageEvent(isGoUp: true));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: EdgeInsets.only(right: 12),
                          width: 26,
                          height: 26,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (goToUpEnable)
                                ? AppColors.iconPrimaryDefault
                                : AppColors.iconPrimaryDisable,
                          ),
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Assets.icons.icArrowLeft.svg(),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!goToDownEnable) return;
                        bloc.add(GoToMessageEvent());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: EdgeInsets.only(right: 12),
                          width: 26,
                          height: 26,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (goToDownEnable)
                                ? AppColors.iconPrimaryDefault
                                : AppColors.iconPrimaryDisable,
                          ),
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Assets.icons.icArrowLeft.svg(),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerGrayStrong3,
              ),
              child: Row(
                children: [
                  Assets.icons.icSearch.svg(
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 12),
                  BlocSelector<WSDetailBloc, WSDetailState, String>(
                    selector: (state) {
                      return state.searchKeyword;
                    },
                    builder: (context, state) {
                      if (state.isEmpty) {
                        return Text(
                          textAlign: TextAlign.start,
                          "search.no_result".tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            height: 20 / 14,
                            fontFamily: FontFamily.segoeUI,
                            color: AppColors.textDefaultTextSub2,
                          ),
                        );
                      }
                      return BlocSelector<
                        WSDetailBloc,
                        WSDetailState,
                        (int, List<MessageEntity>)
                      >(
                        selector: (state) {
                          return (
                            state.indexSearchMessage,
                            state.messageSearchResults,
                          );
                        },
                        builder: (context, state) {
                          final index = state.$1;
                          final total = state.$2.length;
                          return Text(
                            textAlign: TextAlign.start,
                            "${index + 1} of $total",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              height: 20 / 14,
                              fontFamily: FontFamily.segoeUI,
                              color: AppColors.textDefaultTextSub2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      );
                    },
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      if (bloc.state.messageSearchResults.isEmpty) return;
                      final messageId = await context.router.push<String>(
                        MessageSearchResultsListRoute(
                          workspaceId: bloc.groupId,
                          searchMessage: bloc.state.searchKeyword,
                          workspaceName: groupName,
                        ),
                      );
                      if (messageId == null) return;
                      bloc.add(JumpToMessageEvent(messageId: messageId));
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "search.show_as_list".tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: FontFamily.segoeUI,
                          fontSize: 16,
                          height: 24 / 16,
                          color: AppColors.iconAlertInfo,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GroupRemovedView extends StatelessWidget {
  const _GroupRemovedView({super.key, required WSDetailBloc bloc})
    : _bloc = bloc;

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
