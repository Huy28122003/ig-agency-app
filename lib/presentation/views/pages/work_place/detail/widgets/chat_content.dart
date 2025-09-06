import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../domain/entities/message/message.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../widgets/chat_bubble/chat_message_bubble.dart';
import '../../../../widgets/chat/pinned_message_section.dart';
import '../../../../widgets/chat/system_message.dart';
import '../workspace_detail_bloc.dart';

const double _kMaxWidthContentRatio = 277 / 390;

class ChatContent extends StatefulWidget {
  const ChatContent({super.key, this.horizontalPadding = 12});

  final double horizontalPadding;

  @override
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  late final WSDetailBloc _bloc;
  late final String userId;

  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    _bloc = context.read<WSDetailBloc>();

    userId = _bloc.userId;

    _scrollController.addListener(_onScrollListener);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!_scrollController.hasClients) return;

      final position = _scrollController.position;
      if (position.maxScrollExtent > 0) {
        _scrollController.jumpTo(position.maxScrollExtent);
      }
    });
  }

  void _onScrollListener() {
    final isScrollToBottom =
        _scrollController.position.pixels <=
        _scrollController.position.maxScrollExtent - 100;

    if (_bloc.state.isScrollToBottom != isScrollToBottom) {
      _bloc.add(UpdateScrollPositionEvent(isScrollToBottom: isScrollToBottom));
    }
  }

  void _scrollToBottom({bool animated = false}) {
    if (_scrollController.hasClients) {
      final position = _scrollController.position.maxScrollExtent;
      if (animated) {
        _scrollController.animateTo(
          position,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(position);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width * _kMaxWidthContentRatio;

    return BlocBuilder<WSDetailBloc, WSDetailState>(
      buildWhen: (previous, current) =>
          previous.pinnedMessageSummary != current.pinnedMessageSummary,
      builder: (context, state) {
        final pinnedMessageSummary = state.pinnedMessageSummary;
        final hasPinnedMessages =
            pinnedMessageSummary?.hasPinnedMessages ?? false;

        return Stack(
          children: [
            BlocSelector<WSDetailBloc, WSDetailState, List<MessageEntity>>(
              selector: (state) {
                return state.messages;
              },
              builder: (context, messages) {
                return ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.only(top: hasPinnedMessages ? 56 : 0),
                  itemBuilder: (_, index) {
                    final message = messages[index];
                    if (message.content is SystemMessageContent) {
                      final systemMessage =
                          message.content as SystemMessageContent;
                      return SystemMessage(
                        message: systemMessage.message,
                        horizontalPadding: widget.horizontalPadding,
                      );
                    }
                    return ChatMessageBubble(
                      maxWidth: maxWidth,
                      horizontalPadding: widget.horizontalPadding,
                      message: messages[index],
                      isMe: message.sender.id == userId,
                      onReply: () {
                        _bloc.add(ReplyToMessageEvent(message: message));
                      },
                    );
                  },
                  separatorBuilder: (_, index) {
                    final currentMessage = messages[index];
                    final nextMessage = messages[index + 1];

                    if (currentMessage.isSystem && nextMessage.isSystem) {
                      return const SizedBox(height: 0);
                    }
                    return const SizedBox(height: 16);
                  },
                  itemCount: messages.length,
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
              selector: (state) => state.isScrollToBottom,
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
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
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
    );
  }
}
