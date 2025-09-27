import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/work_place/detail/workspace_detail_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../../../domain/entities/message/message_entity.dart';
import '../../../../../../domain/enums/send_message_type.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../resources/colors.dart';
import '../../../../../routers/app_router.dart';
import '../../../../modal/pinned_message/pinned_message_bottom_sheet.dart';
import '../../../../ui_models/pinned_message_summary_ui_model.dart';
import '../../../../widgets/chat/pinned_message_section.dart';
import '../../../../widgets/chat_input/chat_input_bar.dart';
import '../../../../widgets/chat_input/tag_user_list_view.dart';
import 'chat_content.dart';
import 'search_result_bar.dart';

class GroupChatView extends StatelessWidget {
  const GroupChatView({
    super.key,
    required this.bloc,
    required this.focusNode,
    required this.groupName,
    this.screenType = DeviceScreenType.mobile,
  });

  final WSDetailBloc bloc;
  final FocusNode focusNode;
  final String groupName;
  final DeviceScreenType screenType;

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
                          Expanded(child: ChatContent(screenType: screenType)),
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
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: _buildResultNavigation(),
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
                      return SearchResultsBar(groupName: groupName);
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
            // if (state)
            //   Positioned(
            //     bottom: 0,
            //     left: 0,
            //     right: 0,
            //     child: SearchResultsBar(groupName: groupName),
            //   ),
          ],
        );
      },
    );
  }

  Widget _buildResultNavigation() {
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
          ],
        );
      },
    );
  }
}
