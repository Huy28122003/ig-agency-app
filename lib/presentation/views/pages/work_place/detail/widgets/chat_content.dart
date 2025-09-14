import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../../../domain/enums/message_enums.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../shared/commons/enums/status.dart';
import '../../../../../resources/colors.dart';
import '../../../../widgets/chat_bubble/chat_message_bubble.dart';
import '../../../../widgets/chat/pinned_message_section.dart';
import '../../../../ui_models/chat_message_ui_model.dart';
import '../workspace_detail_bloc.dart';
import 'pinned_message_bottom_sheet.dart';

const double _kMaxWidthChatBubbleContentRatio = 277 / 390;
const double _kMaxWidthChatReplyContentRatio = 174 / 277;

class ChatContent extends StatefulWidget {
  const ChatContent({super.key, this.horizontalPadding = 12});

  final double horizontalPadding;

  @override
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  late final WSDetailBloc _bloc;

  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _bloc = context.read<WSDetailBloc>();

    _itemPositionsListener.itemPositions.addListener(_onScrollListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollToBottom();
    });
  }

  void _onScrollListener() {
    final state = _bloc.state;
    final positions = _itemPositionsListener.itemPositions.value;

    if (positions.isNotEmpty && state.chatMessages.isNotEmpty) {
      final lastVisibleItem = positions.last;
      final needLoadMore =
          lastVisibleItem.index == 0 &&
          lastVisibleItem.itemLeadingEdge < 0 &&
          state.needLoadMoreOldMessages;
      if (needLoadMore) {
        // load more messages
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 300), () {
          _bloc.add(LoadMoreChatMessagesEvent());
        });
      }

      final firstVisibleItem = positions.first;
      if (firstVisibleItem.index < state.chatMessages.length - 1 &&
          !state.showScrollToBottomIcon) {
        _bloc.add(ToggleShowScrollToBottomIcon());
      } else if (firstVisibleItem.index == state.chatMessages.length - 1 &&
          state.showScrollToBottomIcon) {
        _bloc.add(ToggleShowScrollToBottomIcon());
      }
    }
  }

  void _scrollToBottom() {
    if (_bloc.state.chatMessages.isNotEmpty) {
      final position = _bloc.state.chatMessages.length - 1;
      _itemScrollController.jumpTo(index: position);
    }
  }

  void _scrollToTop() {
    if (_bloc.state.chatMessages.isNotEmpty) {
      _itemScrollController.jumpTo(index: 0);
    }
  }

  void _jumpToMessage(int index) {
    if (index >= 0 && index < _bloc.state.chatMessages.length) {
      _itemScrollController.jumpTo(index: index, alignment: 0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth =
        MediaQuery.sizeOf(context).width * _kMaxWidthChatBubbleContentRatio;
    final maxWidthReply = maxWidth * _kMaxWidthChatReplyContentRatio;

    return MultiBlocListener(
      listeners: [
        BlocListener<WSDetailBloc, WSDetailState>(
          listenWhen: (previous, current) =>
              previous.scrollToBottom != current.scrollToBottom,
          listener: (context, state) {
            if (state.scrollToBottom) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                _scrollToBottom();
                _bloc.add(ResetScrollToBottomEvent());
              });
            }
          },
        ),
        BlocListener<WSDetailBloc, WSDetailState>(
          listenWhen: (previous, current) =>
              previous.jumpToMessageIndex != current.jumpToMessageIndex,
          listener: (context, state) {
            if (state.jumpToMessageIndex != null) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                _jumpToMessage(state.jumpToMessageIndex!);
                _bloc.add(ResetJumpToMessageEvent());
              });
            }
          },
        ),
        BlocListener<WSDetailBloc, WSDetailState>(
          listenWhen: (previous, current) =>
              previous.scrollToTop != current.scrollToTop,
          listener: (context, state) {
            if (state.scrollToTop) {
              _scrollToTop();
              _bloc.add(ResetScrollToTopEvent());
            }
          },
        ),
      ],
      child: BlocBuilder<WSDetailBloc, WSDetailState>(
        buildWhen: (previous, current) =>
            previous.pinnedMessageSummary != current.pinnedMessageSummary,
        builder: (context, state) {
          final pinnedMessageSummary = state.pinnedMessageSummary;
          final hasPinnedMessages =
              pinnedMessageSummary?.hasPinnedMessages ?? false;

          return Stack(
            children: [
              BlocSelector<
                WSDetailBloc,
                WSDetailState,
                (List<ChatMessageUIModel>, PagingStatus)
              >(
                selector: (state) {
                  return (state.chatMessages, state.chatMessagesPagingStatus);
                },
                builder: (context, state) {
                  final (chatMessages, pagingStatus) = state;

                  return Padding(
                    padding: EdgeInsets.only(top: hasPinnedMessages ? 56 : 0),
                    child: Column(
                      children: [
                        if (pagingStatus == PagingStatus.loading)
                          SizedBox(
                            height: 56,
                            child: const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                        Expanded(
                          child: ScrollablePositionedList.builder(
                            itemScrollController: _itemScrollController,
                            itemPositionsListener: _itemPositionsListener,
                            physics: const ClampingScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 20),
                            itemBuilder: (_, index) {
                              final uiModel = chatMessages[index];

                              return ChatMessageBubble(
                                key: ValueKey(
                                  '${uiModel.message.id} - ${uiModel.shouldShowTime}',
                                ),
                                maxWidth: maxWidth,
                                maxWidthReply: maxWidthReply,
                                horizontalPadding: widget.horizontalPadding,
                                uiModel: uiModel,
                                userId: _bloc.userId,
                                onTap: () {
                                  final messageId = uiModel.message.id;
                                  if (uiModel.message.type ==
                                          MessageType.text &&
                                      !uiModel.showTime) {
                                    if (!uiModel.shouldShowTime) {
                                      _bloc.add(
                                        ShowTimeEvent(messageId: messageId),
                                      );
                                    } else if (uiModel.shouldShowTime) {
                                      _bloc.add(DisableShowTimeEvent());
                                    }
                                  }
                                },
                                onReply: () {
                                  _bloc.add(
                                    ReplyToMessageEvent(
                                      message: uiModel.message,
                                    ),
                                  );
                                },
                                onReplyTap: (messageId) {
                                  _bloc.add(
                                    JumpToMessageEvent(messageId: messageId),
                                  );
                                },
                              );
                            },
                            itemCount: chatMessages.length,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              if (hasPinnedMessages)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: PinnedMessageSection(
                      pinnedMessageSummary: pinnedMessageSummary!,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          useSafeArea: true,
                          elevation: 0,
                          backgroundColor:
                              AppColors.surfaceContainerGrayStrong0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          barrierColor: Colors.black.withValues(alpha: 0.68),
                          isScrollControlled: true,
                          builder: (context) {
                            return PinnedMessagesBottomSheet(
                              workspaceId: _bloc.workspaceId,
                              onTap: (messageId) {
                                _bloc.add(
                                  JumpToMessageEvent(messageId: messageId),
                                );
                                Navigator.pop(context);
                              },
                              onUnpinSuccess: () {
                                _bloc.add(GetPinnedMessageSummaryEvent());
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),

              Positioned(
                top: hasPinnedMessages ? 76 : 20,
                right: widget.horizontalPadding,
                child: GestureDetector(
                  child: Container(
                    height: 44,
                    width: 44,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: CircleBorder(),
                      shadows: [
                        BoxShadow(
                          color: Color(0x1E000000),
                          blurRadius: 10,
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          ),
                        ),
                        Assets.icons.icTranslate.svg(width: 24, height: 24),
                      ],
                    ),
                  ),
                ),
              ),

              BlocSelector<WSDetailBloc, WSDetailState, bool>(
                selector: (state) => state.showScrollToBottomIcon,
                builder: (context, showScrollToTopButton) {
                  return AnimatedPositioned(
                    bottom: showScrollToTopButton ? 10 : -44,
                    right: 0,
                    left: 0,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: GestureDetector(
                        onTap: () {
                          _scrollToBottom();
                        },
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: Assets.icons.icArrowCircleSize32.svg(
                            width: 32,
                            height: 32,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _itemPositionsListener.itemPositions.removeListener(_onScrollListener);
    super.dispose();
  }
}

// /// A custom ScrollPhysics that maintains the user's scroll position
// /// when new items are added at the top of a ListView.
// class KeepScrollPositionPhysics extends ScrollPhysics {
//   const KeepScrollPositionPhysics({super.parent});

//   @override
//   KeepScrollPositionPhysics applyTo(ScrollPhysics? ancestor) {
//     return KeepScrollPositionPhysics(parent: buildParent(ancestor));
//   }

//   @override
//   double adjustPositionForNewDimensions({
//     required ScrollMetrics oldPosition,
//     required ScrollMetrics newPosition,
//     required bool isScrolling,
//     required double velocity,
//   }) {
//     final basePosition = super.adjustPositionForNewDimensions(
//       oldPosition: oldPosition,
//       newPosition: newPosition,
//       isScrolling: isScrolling,
//       velocity: velocity,
//     );

//     double beforeMaxScrollExtent = oldPosition.maxScrollExtent;
//     double afterMaxScrollExtent = newPosition.maxScrollExtent;
//     double scrollOffsetDifference =
//         afterMaxScrollExtent - beforeMaxScrollExtent;

//     if (scrollOffsetDifference > 0) {
//       return oldPosition.pixels + scrollOffsetDifference;
//     }

//     if (oldPosition.pixels >= beforeMaxScrollExtent - 50.0) {
//       return newPosition.maxScrollExtent;
//     }

//     return basePosition;
//   }
// }
