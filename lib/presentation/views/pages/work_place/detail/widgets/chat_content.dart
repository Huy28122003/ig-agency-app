import 'package:flutter/material.dart';

import '../../../../widgets/chat/chat_message_bubble.dart';

class ChatContent extends StatelessWidget {
  const ChatContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, index) => ChatMessageBubble(
        senderName: 'John Doe',
        message: 'Hello, how are you?',
        time: '12:00',
        isOwnMessage: false,
      ),
      separatorBuilder: (_, _) => SizedBox(height: 16),
      itemCount: 10,
    );
  }
}
