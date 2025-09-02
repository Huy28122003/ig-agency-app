import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/chat/reply_message_section.dart';
import '../../../../widgets/circle_network_avatar.dart';
import '../../../../widgets/chat/chat_input_bar.dart';
import '../../../../widgets/chat/pinned_message_section.dart';
import '../widgets/chat_content.dart';

class WorkspaceDetailMobileLayout extends StatelessWidget {
  const WorkspaceDetailMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '29',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            CircleNetworkAvatar(
              imageUrl: 'https://example.com/avatar.jpg',
              size: 40,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Whales - IG Agency 8%',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '99 Members, 29 Online',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: PinnedMessageSection(
              senderName: 'Customer',
              url: 'https://docs.google.com/spreadsheets/d/16...',
              moreCount: 99,
              message:
                  'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable.',
              time: '6:32',
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                ChatContent(),

                // Translate button
                Positioned(
                  top: 20,
                  right: 12,
                  child: GestureDetector(
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Icon(Icons.translate_rounded, size: 24),
                    ),
                  ),
                ),

                // Scroll button
                Positioned(
                  bottom: 10,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: Icon(Icons.arrow_circle_down_rounded, size: 32),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ReplyMessageSection(),
          ChatInputBar(),
        ],
      ),
    );
  }
}
