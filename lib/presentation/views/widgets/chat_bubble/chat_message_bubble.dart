import 'package:flutter/material.dart';
import 'package:ig_agency_app/shared/extensions/datetime_ext.dart';
import '../../../../domain/entities/message/message.dart';
import '../../../../domain/enums/message_enums.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../resources/colors.dart';
import '../circle_network_avatar.dart';
import '../custom_context_menu.dart';
import 'chat_bubble_animation_helper.dart';
import '../../../../shared/commons/constants/chat_bubble_constants.dart';
import 'chat_bubble_content.dart';
import 'chat_bubble_sender_info.dart';
import 'chat_buble_content_with_reply.dart';
import 'reply_icon.dart';

class ChatMessageBubble extends StatefulWidget {
  const ChatMessageBubble({
    super.key,
    required this.maxWidth,
    required this.maxWidthReply,
    required this.horizontalPadding,
    required this.userId,
    required this.message,
    required this.shouldShowTime,
    required this.shouldShowAvatar,
    required this.shouldShowUserName,
    required this.isContinuation,
    this.onReply,
    this.onTap,
    this.onReplyTap,
  });

  final double maxWidth;
  final double maxWidthReply;
  final MessageEntity message;
  final double horizontalPadding;
  final String userId;
  final VoidCallback? onReply;
  final VoidCallback? onTap;
  final Function(String messageId)? onReplyTap;

  final bool shouldShowTime;
  final bool shouldShowAvatar;
  final bool shouldShowUserName;
  final bool isContinuation;

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  late MessageEntity _message;
  late bool _shouldShowTime;
  late bool _shouldShowAvatar;
  late bool _shouldShowUserName;
  late bool _isContinuation;
  late ChatBubbleAnimationHelper _animationHelper;

  final ValueNotifier<double> _dragDistance = ValueNotifier(0.0);
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _message = widget.message;
    _shouldShowTime = widget.shouldShowTime;
    _shouldShowAvatar = widget.shouldShowAvatar;
    _shouldShowUserName = widget.shouldShowUserName;
    _isContinuation = widget.isContinuation;
    _animationHelper = ChatBubbleAnimationHelper(
      isMe: isMe,
      horizontalPadding: widget.horizontalPadding,
    );
  }

  @override
  void didUpdateWidget(covariant ChatMessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.message != oldWidget.message) {
      _message = widget.message;
    }
    if (widget.shouldShowTime != oldWidget.shouldShowTime) {
      _shouldShowTime = widget.shouldShowTime;
      _shouldShowAvatar = widget.shouldShowAvatar;
      _shouldShowUserName = widget.shouldShowUserName;
      _isContinuation = widget.isContinuation;
    }
  }

  bool get isMe => widget.userId == widget.message.sender.id;

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_shouldShowTime)
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _message.createdAt.toShortDateString().toUpperCase(),
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
        Padding(
          padding: EdgeInsets.only(
            top: _isContinuation
                ? _message.type == MessageType.system
                      ? ChatBubbleConstants.continuationSystemVerticalPadding
                      : ChatBubbleConstants.continuationVerticalPadding
                : 16,
          ),
          child: _message.content is SystemMessageContent
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.horizontalPadding,
                  ),
                  child: Text(
                    (_message.content as SystemMessageContent).message,
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
                  // behavior: HitTestBehavior.opaque,
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
                                if (_shouldShowAvatar) ...[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: widget.horizontalPadding,
                                    ),
                                    child: Opacity(
                                      opacity: _animationHelper
                                          .getAvatarOpacity(value),
                                      child: ChatAvatar(
                                        key: ValueKey(_message.sender.id),
                                        imageUrl: _message.sender.avatarUrl,
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
                                  child: CustomContextMenu(
                                    horizontalPadding: widget.horizontalPadding,
                                    // menuAlignment: isMe
                                    //     ? MenuAlignment.right
                                    //     : MenuAlignment.left,
                                    childAlignment: isMe
                                        ? MenuAlignment.right
                                        : MenuAlignment.left,
                                    actions: [
                                      CustomContextMenuAction(
                                        text: 'Reply',
                                        onTap: widget.onReply,
                                      ),
                                      CustomContextMenuAction(
                                        text: 'Forward',
                                        onTap: () {},
                                      ),
                                      CustomContextMenuAction(
                                        text: _message.isPinned ? 'Unpin' : 'Pin',
                                        onTap: () {},
                                      ),
                                      CustomContextMenuAction(
                                        text: 'Copy Message',
                                        onTap: () {},
                                      ),
                                      CustomContextMenuAction(
                                        text: 'Copy Name',
                                        onTap: () {},
                                      ),
                                      CustomContextMenuAction(
                                        text: 'Delete',
                                        onTap: () {},
                                      ),
                                    ],
                                    child: Column(
                                      crossAxisAlignment: isMe
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        if ((!isMe ||
                                                (isMe &&
                                                    _message.reply != null)) &&
                                            _shouldShowUserName) ...[
                                          ChatBubbleSenderInfo(
                                            message: _message,
                                            userId: widget.userId,
                                            isMe: isMe,
                                          ),
                                        ],
                                        _message.reply != null
                                            ? ChatBubbleContentWithReply(
                                                key: ValueKey(
                                                  '${_message.id}-reply',
                                                ),
                                                message: _message,
                                                replyMessage: _message.reply!,
                                                maxWidth: widget.maxWidth,
                                                maxWidthReply:
                                                    widget.maxWidthReply,
                                                isMe: isMe,
                                                onTap: widget.onReplyTap,
                                              )
                                            : ChatBubbleContent(
                                                key: ValueKey(
                                                  '${_message.id}-no-reply',
                                                ),
                                                message: _message,
                                                maxWidth: widget.maxWidth,
                                              ),
                                      ],
                                    ),
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
        ),
      ],
    );
  }
}

class ChatAvatar extends StatelessWidget {
  final String imageUrl;
  const ChatAvatar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleNetworkAvatar(
      imageUrl: imageUrl,
      size: ChatBubbleConstants.avatarSize,
    );
  }
}
