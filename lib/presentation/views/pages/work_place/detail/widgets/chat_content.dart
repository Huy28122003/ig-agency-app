import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../domain/entities/message/message.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../widgets/chat/chat_message_bubble.dart';
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
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isScrollToBottom = ValueNotifier(false);
  late final String userId;
  @override
  void initState() {
    super.initState();

    userId = context.read<WSDetailBloc>().userId;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels <=
          _scrollController.position.maxScrollExtent - 100) {
        if (!_isScrollToBottom.value) {
          _isScrollToBottom.value = true;
        }
      } else {
        if (_isScrollToBottom.value) {
          _isScrollToBottom.value = false;
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width * _kMaxWidthContentRatio;
    return Stack(
      children: [
        BlocSelector<WSDetailBloc, WSDetailState, List<MessageEntity>>(
          selector: (state) {
            return state.messages;
          },
          builder: (context, messages) {
            return ListView.separated(
              controller: _scrollController,
              itemBuilder: (_, index) {
                final message = messages[index];
                if (message.content is SystemMessageContent) {
                  final systemMessage = message.content as SystemMessageContent;
                  return SystemMessage(
                    message: systemMessage.message,
                    horizontalPadding: widget.horizontalPadding,
                  );
                }
                return ChatMessageBubble(
                  maxWidth: maxWidth,
                  horizontalPadding: widget.horizontalPadding,
                  message: messages[index],
                  isOwnMessage: message.sender.id == userId,
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

        // Translate button
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

        // Scroll button
        ValueListenableBuilder(
          valueListenable: _isScrollToBottom,
          builder: (context, showScrollToTopButton, child) {
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
  }
}
