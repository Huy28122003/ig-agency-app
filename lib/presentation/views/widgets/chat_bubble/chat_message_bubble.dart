import 'package:flutter/material.dart';
import '../../../../domain/entities/message/message.dart';
import '../../../../domain/enums/message_enums.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../resources/colors.dart';
import '../circle_network_avatar.dart';
import 'chat_bubble_animation_helper.dart';
import '../../../../shared/commons/constants/chat_bubble_constants.dart';
import 'chat_bubble_content.dart';
import 'chat_bubble_sender_info.dart';
import '../../ui_models/chat_message_ui_model.dart';
import 'reply_icon.dart';

class ChatMessageBubble extends StatefulWidget {
  const ChatMessageBubble({
    super.key,
    required this.maxWidth,
    required this.maxWidthReply,
    required this.horizontalPadding,
    required this.userId,
    required this.uiModel,
    this.onReply,
    this.onTap,
  });

  final double maxWidth;
  final double maxWidthReply;
  final ChatMessageUIModel uiModel;
  final double horizontalPadding;
  final String userId;
  final VoidCallback? onReply;
  final VoidCallback? onTap;
  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  late ChatMessageUIModel _uiModel;
  late ChatBubbleAnimationHelper _animationHelper;

  final ValueNotifier<double> _dragDistance = ValueNotifier(0.0);
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _uiModel = widget.uiModel;
    _animationHelper = ChatBubbleAnimationHelper(
      isMe: isMe,
      horizontalPadding: widget.horizontalPadding,
    );
  }

  bool get isMe => widget.userId == widget.uiModel.message.sender.id;

  void _onPanStart(DragStartDetails details) {
    _isDragging = true;
    _dragDistance.value = 0.0;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    _dragDistance.value += details.delta.dx;

    if (isMe) {
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
    if (isMe) {
      return _dragDistance.value < -ChatBubbleConstants.messageThreshold;
    }
    return _dragDistance.value > ChatBubbleConstants.messageThreshold;
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
    if (isMe) {
      return _dragDistance.value < -ChatBubbleConstants.replyIconThreshold;
    }
    return _dragDistance.value > ChatBubbleConstants.replyIconThreshold;
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
      isMe: isMe,
      horizontalPadding: widget.horizontalPadding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final MessageEntity message = _uiModel.message;
    final bool shouldShowAvatar = _uiModel.shouldShowAvatar;
    final bool shouldShowUserName = _uiModel.shouldShowUserName;
    final bool isContinuation = _uiModel.isContinuation;

    return Padding(
      padding: EdgeInsets.only(
        top: isContinuation
            ? message.type == MessageType.system
                  ? ChatBubbleConstants.continuationSystemVerticalPadding
                  : ChatBubbleConstants.continuationVerticalPadding
            : 16,
      ),
      child: message.content is SystemMessageContent
          ? Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.horizontalPadding,
              ),
              child: Text(
                (message.content as SystemMessageContent).message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimaryTextDefault,
                  fontSize: 13,
                  fontFamily: FontFamily.segoeUI,
                  fontWeight: FontWeight.w600,
                  height: 1.54,
                ),
              ),
            )
          : GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: SizedBox(
                width: double.infinity,
                child: ValueListenableBuilder(
                  valueListenable: _dragDistance,
                  builder: (context, value, child) {
                    return GestureDetector(
                      onTap: widget.onTap,
                      child: Stack(
                        alignment: isMe
                            ? Alignment.bottomRight
                            : Alignment.bottomLeft,
                        children: [
                          if (!isMe) ...[
                            if (shouldShowAvatar) ...[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: widget.horizontalPadding,
                                ),
                                child: Opacity(
                                  opacity: _animationHelper.getAvatarOpacity(
                                    value,
                                  ),
                                  child: CircleNetworkAvatar(
                                    imageUrl: message.sender.avatarUrl,
                                    size: ChatBubbleConstants.avatarSize,
                                  ),
                                ),
                              ),
                            ] else ...[
                              SizedBox(
                                height: ChatBubbleConstants.avatarSize,
                                width: ChatBubbleConstants.avatarSize,
                              ),
                            ],
                            const SizedBox(width: 8),
                          ],
                          Transform.translate(
                            offset: Offset(value, 0),
                            child: Padding(
                              padding: isMe
                                  ? EdgeInsets.only(
                                      right: widget.horizontalPadding,
                                    )
                                  : EdgeInsets.only(
                                      left:
                                          widget.horizontalPadding +
                                          ChatBubbleConstants.avatarSize +
                                          8,
                                    ),
                              child: Column(
                                crossAxisAlignment: isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  if ((!isMe ||
                                          (isMe && message.reply != null)) &&
                                      shouldShowUserName) ...[
                                    ChatBubbleSenderInfo(
                                      message: message,
                                      userId: widget.userId,
                                      isMe: isMe,
                                    ),
                                  ],
                                  Flexible(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return Stack(
                                          children: [
                                            // TODO hoannk: UI message is reply
                                            ChatBubbleContent(
                                              message: message,
                                              maxWidth: widget.maxWidth,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _buildReplyIcon(value),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
