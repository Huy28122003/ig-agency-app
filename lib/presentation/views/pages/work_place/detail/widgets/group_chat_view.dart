import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/work_place/detail/workspace_detail_bloc.dart';

import '../../../../../../domain/entities/message/message_entity.dart';
import '../../../../../../domain/enums/send_message_type.dart';
import '../../../../../routers/app_router.dart';
import '../../../../modal/pinned_message/pinned_message_bottom_sheet.dart';
import '../../../../ui_models/pinned_message_summary_ui_model.dart';
import '../../../../widgets/chat/pinned_message_section.dart';
import '../../../../widgets/chat_input/chat_input_bar.dart';
import '../../../../widgets/chat_input/tag_user_list_view.dart';
import 'chat_content.dart';
import 'search.dart';

class GroupChatView extends StatelessWidget {
  const GroupChatView({
    super.key,
    required this.bloc,
    required this.focusNode,
    required this.groupName,
    this.isMobile = true,
  });

  final WSDetailBloc bloc;
  final FocusNode focusNode;
  final String groupName;
  final bool isMobile;

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
