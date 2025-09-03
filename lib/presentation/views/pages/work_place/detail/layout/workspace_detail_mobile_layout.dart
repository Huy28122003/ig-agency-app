import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../domain/entities/message/message_entity.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../../../../widgets/circle_network_avatar.dart';
import '../../../../widgets/chat/chat_input_bar.dart';
import '../../../../widgets/chat/pinned_message_section.dart';
import '../widgets/chat_content.dart';
import '../workspace_detail_bloc.dart';

class WorkspaceDetailMobileLayout extends StatelessWidget {
  const WorkspaceDetailMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 44,
        toolbarHeight: 60,
        scrolledUnderElevation: 0,
        leading: Stack(
          children: [
            Positioned(
              left: 8,
              top: 0,
              bottom: 0,
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: Assets.icons.icArrowLeft.svg(
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    AppColors.iconDefaultDefault,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () => context.router.pop(),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                height: 18,
                padding: const EdgeInsets.all(2),
                decoration: ShapeDecoration(
                  color: AppColors.iconAlertInfo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
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
          ],
        ),
        titleSpacing: 12,
        title: Row(
          children: [
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
                    style: TextStyle(
                      color: AppColors.textDefaultTextDefault,
                      fontSize: 16,
                      fontFamily: FontFamily.segoeUI,
                      fontWeight: FontWeight.w700,
                      height: 1.50,
                    ),
                  ),
                  Text(
                    '99 Members, 29 Online',
                    style: TextStyle(
                      color: AppColors.textDefaultTextSub2,
                      fontSize: 14,
                      fontFamily: FontFamily.segoeUI,
                      fontWeight: FontWeight.w400,
                      height: 1.14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            BlocSelector<WSDetailBloc, WSDetailState, List<MessageEntity>>(
              selector: (state) {
                return state.messages;
              },
              builder: (context, messages) {
                final latestPinnedMessage = messages.lastOrNull;
                final hasPinnedMessage = latestPinnedMessage != null;

                if (!hasPinnedMessage) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: PinnedMessageSection(
                    latestPinnedMessage: latestPinnedMessage,
                    totalMessages: messages.length,
                  ),
                );
              },
            ),
            Expanded(child: ChatContent()),
            ChatInputBar(),
          ],
        ),
      ),
    );
  }
}
