import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:ig_agency_app/shared/extensions/widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../../../shared/commons/enums/status.dart';
import '../../../../../resources/colors.dart';
import '../../../../widgets/chat_bubble/chat_message_bubble.dart';
import '../../../../ui_models/chat_message/chat_message_ui_model.dart';
import '../workspace_detail_bloc.dart';

const double _kMaxWidthChatContentMobileRatio = 277 / 350;
const double _kMaxWidthChatContentTabletRatio = 445 / 598;
const double _kMaxWidthChatContentWebRatio = 717 / 954;
const double _kMaxWidthChatReplyContentRatio = 174 / 277;

class ChatContent extends StatefulWidget {
  const ChatContent({
    super.key,
    this.horizontalPadding = 12,
    this.screenType = DeviceScreenType.mobile,
  });

  final double horizontalPadding;
  final DeviceScreenType screenType;

  @override
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> with WidgetsBindingObserver {
  late final WSDetailBloc _bloc;

  final listViewController = FlutterListViewController();
  final refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    _bloc = context.read<WSDetailBloc>();
    WidgetsBinding.instance.addObserver(this);

    listViewController.addListener(() {
      _onScrollListener();
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = View.of(context).viewInsets.bottom;
    if (bottomInset > 0) {
      if (mounted) {
        _scrollToBottom();
      }
    }
  }

  @override
  void dispose() {
    listViewController.dispose();
    refreshController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onScrollListener() {
    final state = _bloc.state;
    if (state.pageStatus == PageStatus.loaded) {
      if ((listViewController.offset <= 300) && state.showScrollToBottomIcon) {
        _bloc.add(ToggleShowScrollToBottomIcon());
      } else if ((listViewController.offset > 300) &&
          !state.showScrollToBottomIcon) {
        _bloc.add(ToggleShowScrollToBottomIcon());
      }
    }
  }

  void _scrollToBottom() {
    if (_bloc.state.chatMessages.isNotEmpty) {
      final minScrollExtent = listViewController.position.minScrollExtent;
      listViewController.jumpTo(minScrollExtent);
    }
  }

  void _jumpToMessage(String messageId) {
    final index = _bloc.state.chatMessages.indexWhere(
      (uiModel) => uiModel.message.id == messageId,
    );
    if (index >= 0 && index < _bloc.state.chatMessages.length) {
      listViewController.sliverController.jumpToIndex(index, offset: 0.5);
    }
  }

  void _onLoading() async {
    _bloc.add(LoadMoreChatMessagesEvent());
  }

  Future<void> _showDeleteOptionSheet(
    BuildContext context,
    String messageId,
  ) async {
    await showCupertinoModalPopup(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.68),
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _bloc.add(DeleteMessageForEveryoneEvent(messageId: messageId));
            },
            child: Text(
              'Delete for everyone',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.colorsRed,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                height: 1.29,
                letterSpacing: -0.43,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _bloc.add(DeleteMessageForYouEvent(messageId: messageId));
            },
            child: Text(
              'Delete for you',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.colorsRed,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                height: 1.29,
                letterSpacing: -0.43,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.colorsBlue,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              height: 1.29,
              letterSpacing: -0.43,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        final double maxWidthChatBubble = switch (widget.screenType) {
          DeviceScreenType.mobile =>
            _kMaxWidthChatContentMobileRatio * maxWidth,
          DeviceScreenType.tablet =>
            _kMaxWidthChatContentTabletRatio * maxWidth,
          DeviceScreenType.desktop => _kMaxWidthChatContentWebRatio * maxWidth,
          _ => maxWidth,
        };
        final double maxWidthChatReply =
            maxWidthChatBubble * _kMaxWidthChatReplyContentRatio;

        return MultiBlocListener(
          listeners: [
            BlocListener<WSDetailBloc, WSDetailState>(
              listenWhen: (previous, current) =>
                  previous.scrollToBottom != current.scrollToBottom,
              listener: (context, state) {
                if (state.scrollToBottom) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      _scrollToBottom();
                      _bloc.add(ResetScrollToBottomEvent());
                    }
                  });
                }
              },
            ),
            BlocListener<WSDetailBloc, WSDetailState>(
              listenWhen: (previous, current) =>
                  previous.jumpToMessageId != current.jumpToMessageId,
              listener: (context, state) {
                final messageId = state.jumpToMessageId;
                if (messageId != null) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    if (mounted) {
                      _jumpToMessage(messageId);
                    }
                  });
                }
              },
            ),
            BlocListener<WSDetailBloc, WSDetailState>(
              listenWhen: (previous, current) =>
                  previous.pagingStatus != current.pagingStatus,
              listener: (context, state) {
                refreshController.refresh(state.pagingStatus);
              },
            ),
          ],
          child: Stack(
            children: [
              BlocSelector<
                WSDetailBloc,
                WSDetailState,
                (List<ChatMessageUIModel>, bool)
              >(
                selector: (state) {
                  return (state.chatMessages, state.needLoadMoreOldMessages);
                },
                builder: (context, state) {
                  final (chatMessages, needLoadMoreOldMessages) = state;

                  if (chatMessages.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return SmartRefresher(
                    enablePullDown: false,
                    enablePullUp: needLoadMoreOldMessages,
                    footer: CustomFooter(
                      builder: (context, mode) {
                        if (mode == LoadStatus.loading) {
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
                    onLoading: _onLoading,
                    child: FlutterListView(
                      reverse: true,
                      controller: listViewController,
                      physics: const ClampingScrollPhysics(),
                      // cacheExtent: chatMessages.length * 100,
                      delegate: FlutterListViewDelegate(
                        (BuildContext context, int index) {
                          final uiModel = chatMessages[index];
                          final bool shouldShowAvatar =
                              uiModel.shouldShowAvatar;
                          final bool shouldShowUserName =
                              uiModel.shouldShowUserName;
                          final bool isContinuation = uiModel.isContinuation;
                          final bool shouldShowTime =
                              uiModel.showTime || uiModel.shouldShowTime;

                          final double bottomPadding =
                              chatMessages.isNotEmpty && index == 0 ? 20 : 0;
                          return Padding(
                            padding: EdgeInsets.only(bottom: bottomPadding),
                            child: ChatMessageBubble(
                              key: ValueKey(uiModel.message.id),
                              message: uiModel.message,
                              maxWidth: maxWidthChatBubble,
                              maxWidthReply: maxWidthChatReply,
                              horizontalPadding: widget.horizontalPadding,
                              shouldShowTime: shouldShowTime,
                              shouldShowAvatar: shouldShowAvatar,
                              shouldShowUserName: shouldShowUserName,
                              isContinuation: isContinuation,
                              searchText: 'alabama',
                              userId: _bloc.userId,
                              onTap: () {
                                final messageId = uiModel.message.id;
                                _bloc.add(
                                  ToggleShowTimeEvent(messageId: messageId),
                                );
                              },
                              onReply: () {
                                _bloc.add(
                                  ReplyToMessageEvent(message: uiModel.message),
                                );
                              },
                              onReplyTap: (messageId) {
                                _bloc.add(
                                  JumpToMessageEvent(messageId: messageId),
                                );
                              },
                              onPin: () {
                                _bloc.add(
                                  TogglePinMessageFromDetailEvent(
                                    messageId: uiModel.message.id,
                                  ),
                                );
                              },
                              onDelete: () {
                                _showDeleteOptionSheet(
                                  context,
                                  uiModel.message.id,
                                );
                              },
                            ),
                          );
                        },
                        childCount: chatMessages.length,
                        onItemKey: (index) => chatMessages[index].message.id,
                        keepPosition: true,
                        keepPositionOffset: 56,
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
      },
    );
  }
}
