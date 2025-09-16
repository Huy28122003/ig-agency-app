import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../../../domain/enums/message_enums.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../shared/commons/enums/status.dart';
import '../../../../widgets/chat_bubble/chat_message_bubble.dart';
import '../../../../ui_models/chat_message_ui_model.dart';
import '../workspace_detail_bloc.dart';

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

  final listViewController = FlutterListViewController();
  final refreshController = RefreshController(initialRefresh: false);
  double prevScrollOffset = 0;

  @override
  void initState() {
    super.initState();

    _bloc = context.read<WSDetailBloc>();

    listViewController.addListener(() {
      _onRefreshListener();
      _onScrollListener();
    });
  }

  void _onRefreshListener() {
    const torrentDistance = 56;
    var offset = listViewController.offset;
    if (offset <= torrentDistance && prevScrollOffset > torrentDistance) {
      if (!refreshController.isRefresh) {
        refreshController.requestRefresh();
      }
    }
    prevScrollOffset = offset;
  }

  void _onScrollListener() {
    final state = _bloc.state;
    if (state.isInitialized) {
      if ((listViewController.offset >=
              listViewController.position.maxScrollExtent - 100) &&
          state.showScrollToBottomIcon) {
        _bloc.add(ToggleShowScrollToBottomIcon());
      } else if ((listViewController.offset <
              listViewController.position.maxScrollExtent - 100) &&
          !state.showScrollToBottomIcon) {
        _bloc.add(ToggleShowScrollToBottomIcon());
      }
    }
  }

  void _scrollToBottom() {
    if (_bloc.state.chatMessages.isNotEmpty) {
      final position = _bloc.state.chatMessages.length - 1;
      listViewController.sliverController.jumpToIndex(position);
      _bloc.add(ToggleShowScrollToBottomIcon());
    }
  }

  void _jumpToMessage(int index) {
    if (index >= 0 && index < _bloc.state.chatMessages.length) {
      listViewController.sliverController.jumpToIndex(index, offset: 0.5);
    }
  }

  void _onRefresh() async {
    final state = _bloc.state;
    if (state.needLoadMoreOldMessages) {
      refreshController.requestRefresh();
      _bloc.add(LoadMoreChatMessagesEvent());
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
              WidgetsBinding.instance.addPostFrameCallback((_) {
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
              previous.chatMessagesPagingStatus !=
              current.chatMessagesPagingStatus,
          listener: (context, state) {
            if (state.chatMessagesPagingStatus == PagingStatus.loading) return;
            switch (state.chatMessagesPagingStatus) {
              case PagingStatus.loadCompleted:
                refreshController.refreshCompleted();
                break;
              default:
                refreshController.refreshToIdle();
                break;
            }
          },
        ),
      ],
      child: Stack(
        children: [
          BlocSelector<
            WSDetailBloc,
            WSDetailState,
            (List<ChatMessageUIModel>, bool, bool, int)
          >(
            selector: (state) {
              return (
                state.chatMessages,
                state.needLoadMoreOldMessages,
                state.chatMessagesPagingStatus == PagingStatus.loading,
                state.initIndex,
              );
            },
            builder: (context, state) {
              final (
                chatMessages,
                needLoadMoreOldMessages,
                isLoading,
                initIndex,
              ) = state;
              if (chatMessages.isEmpty) {
                return const SizedBox.shrink();
              }

              return SmartRefresher(
                enablePullDown: needLoadMoreOldMessages,
                enablePullUp: false,
                header: CustomHeader(
                  completeDuration: const Duration(milliseconds: 0),
                  builder: (context, mode) {
                    if (mode == RefreshStatus.refreshing) {
                      return SizedBox(
                        height: 56,
                        child: Center(
                          child: const CupertinoActivityIndicator(),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                controller: refreshController,
                onRefresh: _onRefresh,
                child: FlutterListView(
                  controller: listViewController,
                  physics: const ClampingScrollPhysics(),
                  // cacheExtent: chatMessages.length * 100,
                  delegate: FlutterListViewDelegate(
                    (BuildContext context, int index) {
                      final uiModel = chatMessages[index];
                      final bool shouldShowAvatar = uiModel.shouldShowAvatar;
                      final bool shouldShowUserName =
                          uiModel.shouldShowUserName;
                      final bool isContinuation = uiModel.isContinuation;
                      final bool shouldShowTime =
                          uiModel.showTime || uiModel.shouldShowTime;

                      final double bottomPadding =
                          chatMessages.isNotEmpty &&
                              index == chatMessages.length - 1
                          ? 20
                          : 0;
                      return Padding(
                        padding: EdgeInsets.only(bottom: bottomPadding),
                        child: ChatMessageBubble(
                          key: ValueKey(uiModel.message.id),
                          maxWidth: maxWidth,
                          maxWidthReply: maxWidthReply,
                          horizontalPadding: widget.horizontalPadding,
                          message: uiModel.message,
                          shouldShowTime: shouldShowTime,
                          shouldShowAvatar: shouldShowAvatar,
                          shouldShowUserName: shouldShowUserName,
                          isContinuation: isContinuation,
                          userId: _bloc.userId,
                          onTap: () {
                            final messageId = uiModel.message.id;
                            if (uiModel.message.type == MessageType.text &&
                                !uiModel.showTime) {
                              if (!uiModel.shouldShowTime) {
                                _bloc.add(ShowTimeEvent(messageId: messageId));
                              } else if (uiModel.shouldShowTime) {
                                _bloc.add(DisableShowTimeEvent());
                              }
                            }
                          },
                          onReply: () {
                            _bloc.add(
                              ReplyToMessageEvent(message: uiModel.message),
                            );
                          },
                          onReplyTap: (messageId) {
                            _bloc.add(JumpToMessageEvent(messageId: messageId));
                          },
                          onPin: (isPinned) {
                            if (isPinned) {
                              _bloc.add(
                                UnpinMessageFromDetailEvent(
                                  messageId: uiModel.message.id,
                                ),
                              );
                            } else {
                              _bloc.add(
                                PinMessageFromDetailEvent(
                                  messageId: uiModel.message.id,
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                    childCount: chatMessages.length,
                    onItemKey: (index) => chatMessages[index].message.id,
                    keepPosition: true,
                    keepPositionOffset: 56,
                    initIndex: initIndex,
                    firstItemAlign: FirstItemAlign.end,
                  ),
                ),
              );
            },
          ),

          Positioned(
            top: 20,
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
      ),
    );
  }

  @override
  void dispose() {
    listViewController.dispose();
    refreshController.dispose();
    super.dispose();
  }
}
