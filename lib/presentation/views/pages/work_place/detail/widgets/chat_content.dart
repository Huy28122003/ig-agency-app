import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/shared/extensions/datetime_ext.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../../../domain/enums/message_enums.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
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

  @override
  void initState() {
    super.initState();

    _bloc = context.read<WSDetailBloc>();

    _itemPositionsListener.itemPositions.addListener(_onScrollListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollToBottom(animated: false);
    });
  }

  void _onScrollListener() {
    // TODO hoannk: Implement scroll listener
  }

  void _scrollToBottom({bool animated = false}) {
    if (_bloc.state.chatMessages.isNotEmpty) {
      final position = _bloc.state.chatMessages.length - 1;
      if (animated) {
        _itemScrollController.scrollTo(
          index: position,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      } else {
        _itemScrollController.jumpTo(index: position);
      }
    }
  }

  void _jumpToMessage(int index) {
    _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      alignment: 0.5,
    );
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
                List<ChatMessageUIModel>
              >(
                selector: (state) {
                  return state.chatMessages;
                },
                builder: (context, chatMessages) {
                  return ScrollablePositionedList.builder(
                    itemScrollController: _itemScrollController,
                    itemPositionsListener: _itemPositionsListener,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.only(
                      top: hasPinnedMessages ? 56 : 0,
                      bottom: 20,
                    ),
                    itemBuilder: (_, index) {
                      final uiModel = chatMessages[index];

                      return Column(
                        children: [
                          if (uiModel.shouldShowTime) ...[
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    uiModel.message.createdAt
                                        .toShortDateString()
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: AppColors.textDefaultTextDefault,
                                      fontSize: 14,
                                      fontFamily: FontFamily.segoeUI,
                                      fontWeight: FontWeight.w400,
                                      height: 1.43,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          ChatMessageBubble(
                            maxWidth: maxWidth,
                            maxWidthReply: maxWidthReply,
                            horizontalPadding: widget.horizontalPadding,
                            uiModel: uiModel,
                            userId: _bloc.userId!,
                            onTap: () {
                              final messageId = uiModel.message.id;
                              if (uiModel.message.type == MessageType.text) {
                                if (!uiModel.shouldShowTime &&
                                    messageId != null) {
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
                                ReplyToMessageEvent(message: uiModel.message),
                              );
                            },
                          ),
                        ],
                      );
                    },

                    itemCount: chatMessages.length,
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
                            return BlocProvider.value(
                              value: _bloc..add(LoadPinnedMessagesEvent()),
                              child: PinnedMessagesBottomSheet(
                                onTap: (messageId) {
                                  _bloc.add(
                                    JumpToMessageEvent(messageId: messageId),
                                  );
                                  Navigator.pop(context);
                                },
                              ),
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
}
