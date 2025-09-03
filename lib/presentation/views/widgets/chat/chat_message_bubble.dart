import 'package:flutter/material.dart';
import '../../../../domain/entities/message/message.dart';
import '../circle_network_avatar.dart';

class ChatMessageBubble extends StatefulWidget {
  const ChatMessageBubble({
    super.key,
    required this.horizontalPadding,
    required this.isOwnMessage,
    required this.message,
  });

  final MessageEntity message;
  final double horizontalPadding;
  final bool isOwnMessage;

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  late MessageEntity _message;

  @override
  void initState() {
    super.initState();
    _message = widget.message;
  }

  @override
  Widget build(BuildContext context) {
    final MessageReply? reply = _message.reply;
    final bool hasReply = reply != null;
    return GestureDetector(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.isOwnMessage) ...[
            CircleNetworkAvatar(imageUrl: _message.sender.avatarUrl, size: 32),
            SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: widget.isOwnMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!widget.isOwnMessage) ...[
                  if (hasReply) ...[
                    Text(
                      '${_message.sender.name} replying to ${reply.senderName}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ] else
                    Text(
                      _message.sender.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  SizedBox(height: 4),
                ],
                // Message content
              ],
            ),
          ),
        ],
      ),
    );
  }
}
