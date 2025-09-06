import 'package:flutter/material.dart';
import '../../../../domain/entities/message/message.dart';
import '../circle_network_avatar.dart';
import 'chat_bubble_animation_helper.dart';
import '../../../../shared/commons/constants/chat_bubble_constants.dart';
import 'chat_bubble_content.dart';
import 'chat_bubble_sender_info.dart';
import 'reply_icon.dart';

class ChatMessageBubble extends StatefulWidget {
  const ChatMessageBubble({
    super.key,
    required this.maxWidth,
    required this.horizontalPadding,
    required this.isMe,
    required this.message,
    this.onReply,
  });

  final double maxWidth;
  final MessageEntity message;
  final double horizontalPadding;
  final bool isMe;
  final VoidCallback? onReply;

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  late MessageEntity _message;
  late ChatBubbleAnimationHelper _animationHelper;

  final ValueNotifier<double> _dragDistance = ValueNotifier(0.0);
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _message = widget.message;
    _animationHelper = ChatBubbleAnimationHelper(
      isMe: widget.isMe,
      horizontalPadding: widget.horizontalPadding,
    );
  }

  void _onPanStart(DragStartDetails details) {
    _isDragging = true;
    _dragDistance.value = 0.0;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    _dragDistance.value += details.delta.dx;

    if (widget.isMe) {
      if (_dragDistance.value > 0) _dragDistance.value = 0;
      if (_dragDistance.value < -ChatBubbleConstants.maxDragDistance) {
        _dragDistance.value = -ChatBubbleConstants.maxDragDistance;
      }
    } else {
      if (_dragDistance.value < 0) _dragDistance.value = 0;
      if (_dragDistance.value > ChatBubbleConstants.maxDragDistance) {
        _dragDistance.value = ChatBubbleConstants.maxDragDistance;
      }
    }
  }

  bool shouldTriggerReply() {
    if (widget.isMe) {
      return _dragDistance.value < -ChatBubbleConstants.messageThreshold;
    } else {
      return _dragDistance.value > ChatBubbleConstants.messageThreshold;
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_isDragging) return;

    _isDragging = false;

    if (shouldTriggerReply()) {
      widget.onReply?.call();
    }

    _dragDistance.value = 0.0;
  }

  bool shouldShowReplyIcon() {
    if (widget.isMe) {
      return _dragDistance.value < -ChatBubbleConstants.replyIconThreshold;
    } else {
      return _dragDistance.value > ChatBubbleConstants.replyIconThreshold;
    }
  }

  Widget _buildReplyIcon(double dragDistance) {
    final opacity = _animationHelper.getReplyIconOpacity(dragDistance);
    final shouldShow = shouldShowReplyIcon();

    if (!shouldShow) {
      return const SizedBox.shrink();
    }

    final iconOffset = _animationHelper.getReplyIconOffset(dragDistance);

    return ReplyIcon(
      opacity: opacity,
      offset: iconOffset,
      isMe: widget.isMe,
      horizontalPadding: widget.horizontalPadding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: ValueListenableBuilder(
        valueListenable: _dragDistance,
        builder: (context, value, child) {
          return Stack(
            alignment: widget.isMe
                ? Alignment.bottomRight
                : Alignment.bottomLeft,
            children: [
              if (!widget.isMe) ...[
                Padding(
                  padding: EdgeInsets.only(left: widget.horizontalPadding),
                  child: Opacity(
                    opacity: _animationHelper.getAvatarOpacity(value),
                    child: CircleNetworkAvatar(
                      imageUrl: _message.sender.avatarUrl,
                      size: ChatBubbleConstants.avatarSize,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Transform.translate(
                offset: Offset(value, 0),
                child: Padding(
                  padding: widget.isMe
                      ? EdgeInsets.only(right: widget.horizontalPadding)
                      : EdgeInsets.only(
                          left:
                              widget.horizontalPadding +
                              ChatBubbleConstants.avatarSize +
                              8,
                        ),
                  child: Column(
                    crossAxisAlignment: widget.isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (!widget.isMe) ...[
                        ChatBubbleSenderInfo(message: _message),
                      ],
                      ChatBubbleContent(
                        message: _message,
                        maxWidth: widget.maxWidth,
                      ),
                    ],
                  ),
                ),
              ),
              _buildReplyIcon(value),
            ],
          );
        },
      ),
    );
  }
}
