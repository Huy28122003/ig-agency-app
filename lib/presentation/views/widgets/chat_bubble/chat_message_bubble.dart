import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ig_agency_app/shared/extensions/date_time_extension.dart';
import '../../../../domain/entities/message/message.dart';
import '../../../../gen/assets.gen.dart';
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
    required this.message,
    required this.maxWidth,
    required this.maxWidthReply,
    this.horizontalPadding = 12,
    this.userId,
    this.shouldShowTime = false,
    this.shouldShowAvatar = false,
    this.shouldShowUserName = false,
    this.isContinuation = false,
    this.onReply,
    this.onTap,
    this.onReplyTap,
    this.onForward,
    this.onPin,
    this.onDelete,
    this.searchText,
  });

  final MessageEntity message;
  final double maxWidth;
  final double maxWidthReply;
  final double horizontalPadding;
  final String? userId;
  final VoidCallback? onReply;
  final VoidCallback? onTap;
  final Function(String messageId)? onReplyTap;

  final bool shouldShowTime;
  final bool shouldShowAvatar;
  final bool shouldShowUserName;
  final bool isContinuation;

  final VoidCallback? onForward;
  final VoidCallback? onPin;
  final VoidCallback? onDelete;
  final String? searchText;

  factory ChatMessageBubble.system({
    required MessageEntity message,
    bool shouldShowTime = false,
    double horizontalPadding = 12,
  }) {
    return ChatMessageBubble(
      message: message,
      maxWidth: 0,
      maxWidthReply: 0,
      shouldShowTime: shouldShowTime,
      horizontalPadding: horizontalPadding,
    );
  }

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  late MessageEntity _message;
  late bool _shouldShowTime;
  late bool _shouldShowAvatar;
  late bool _shouldShowUserName;
  late bool _isContinuation;
  late String? _searchText;
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
    _searchText = widget.searchText;
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
    if (widget.shouldShowTime != oldWidget.shouldShowTime ||
        widget.shouldShowAvatar != oldWidget.shouldShowAvatar ||
        widget.shouldShowUserName != oldWidget.shouldShowUserName ||
        widget.isContinuation != oldWidget.isContinuation) {
      _shouldShowTime = widget.shouldShowTime;
      _shouldShowAvatar = widget.shouldShowAvatar;
      _shouldShowUserName = widget.shouldShowUserName;
      _isContinuation = widget.isContinuation;
    }
    if (widget.searchText != oldWidget.searchText) {
      _searchText = widget.searchText;
    }
  }

  bool get isMe => widget.userId == widget.message.user.id;

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
    final messageContent = _message.content;
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
                  _message.createdAt.formatDateWithTime().toUpperCase(),
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
                ? messageContent.isSystem
                      ? ChatBubbleConstants.continuationSystemVerticalPadding
                      : ChatBubbleConstants.continuationVerticalPadding
                : 16,
          ),
          child: switch (messageContent) {
            SystemMessageContent _ => Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.horizontalPadding,
              ),
              child: Text(
                messageContent.message,
                style: TextStyle(
                  color: AppColors.textPrimaryTextDefault,
                  fontSize: 13,
                  fontFamily: FontFamily.segoeUI,
                  fontWeight: FontWeight.w600,
                  height: 1.54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            _ => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: SizedBox(
                width: double.infinity,
                child: ValueListenableBuilder(
                  valueListenable: _dragDistance,
                  builder: (context, value, child) {
                    return _buildMainChatBubble(value);
                  },
                ),
              ),
            ),
          },
        ),
      ],
    );
  }

  Widget _buildMainChatBubble(double value) {
    final repliedMessage = _message.repliedMessage;
    final messageContent = _message.content;

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: isMe ? Alignment.bottomRight : Alignment.bottomLeft,
        children: [
          if (!isMe) ...[
            if (_shouldShowAvatar) ...[
              Padding(
                padding: EdgeInsets.only(left: widget.horizontalPadding),
                child: Opacity(
                  opacity: _animationHelper.getAvatarOpacity(value),
                  child: ChatAvatar(
                    key: ValueKey(_message.user.id),
                    imageUrl: _message.user.avatar,
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
                  ? EdgeInsets.only(right: widget.horizontalPadding)
                  : EdgeInsets.only(
                      left:
                          widget.horizontalPadding +
                          ChatBubbleConstants.avatarSize +
                          8,
                    ),
              child: CustomContextMenu(
                menuAlignment: isMe ? MenuAlignment.right : MenuAlignment.left,
                childAlignment: isMe ? MenuAlignment.right : MenuAlignment.left,
                actions: [
                  CustomContextMenuAction(
                    text: 'Reply',
                    onTap: widget.onReply,
                    trailingIcon: Assets.icons.icReply.svg(
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                        AppColors.iconDefaultDefault,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  CustomContextMenuAction(
                    text: 'Forward',
                    onTap: widget.onForward,
                    trailingIcon: Transform.flip(
                      flipX: true,
                      child: Assets.icons.icReply.svg(
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                          AppColors.iconDefaultDefault,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  CustomContextMenuAction(
                    text: _message.isPinned ? 'Unpin' : 'Pin',
                    onTap: widget.onPin,
                    trailingIcon: _message.isPinned
                        ? Assets.icons.icUnpin.svg(
                            height: 20,
                            width: 20,
                            colorFilter: ColorFilter.mode(
                              AppColors.iconDefaultDefault,
                              BlendMode.srcIn,
                            ),
                          )
                        : Assets.icons.icPin.svg(
                            height: 20,
                            width: 20,
                            colorFilter: ColorFilter.mode(
                              AppColors.iconDefaultDefault,
                              BlendMode.srcIn,
                            ),
                          ),
                  ),
                  if (messageContent is TextMessageContent)
                    CustomContextMenuAction(
                      text: 'Copy Message',
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: messageContent.text),
                        );
                      },
                      trailingIcon: Assets.icons.icCopy.svg(
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                          AppColors.iconDefaultDefault,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  CustomContextMenuAction(
                    text: 'Copy Name',
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: _message.user.name),
                      );
                    },
                    trailingIcon: Assets.icons.icCopyName.svg(
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                        AppColors.iconDefaultDefault,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  CustomContextMenuAction(
                    text: 'Delete',
                    textColor: AppColors.colorsRed,
                    onTap: widget.onDelete,
                    trailingIcon: Assets.icons.icTrash.svg(
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                        AppColors.iconAlertError,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if ((!isMe || (isMe && repliedMessage != null)) &&
                        _shouldShowUserName) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ChatBubbleSenderInfo(
                          message: _message,
                          userId: widget.userId,
                          isMe: isMe,
                        ),
                      ),
                    ],
                    repliedMessage != null
                        ? ChatBubbleContentWithReply(
                            message: _message,
                            replyMessage: repliedMessage,
                            maxWidth: widget.maxWidth,
                            maxWidthReply: widget.maxWidthReply,
                            isMe: isMe,
                            onTap: widget.onReplyTap,
                            searchText: _searchText,
                          )
                        : ChatBubbleContent(
                            message: _message,
                            maxWidth: widget.maxWidth,
                            searchText: _searchText,
                            isMe: isMe,
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
