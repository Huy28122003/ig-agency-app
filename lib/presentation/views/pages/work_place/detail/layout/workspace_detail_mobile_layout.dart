import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../domain/entities/message/message.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../../../../models/pinned_message_summary_ui_model.dart';
import '../../../../widgets/circle_network_avatar.dart';
import '../../../../widgets/chat/chat_input_bar.dart';
import '../../../../widgets/chat/pinned_message_section.dart';
import '../widgets/chat_content.dart';
import '../workspace_detail_bloc.dart';

class WorkspaceDetailMobileLayout extends StatelessWidget {
  const WorkspaceDetailMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<WSDetailBloc>();

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
              child: Container(
                height: 24,
                width: 24,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => context.router.pop(),
                  child: Assets.icons.icArrowLeft.svg(
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      AppColors.iconDefaultDefault,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                height: 18,
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.iconAlertInfo,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
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
            BlocSelector<
              WSDetailBloc,
              WSDetailState,
              PinnedMessageSummaryUiModel?
            >(
              selector: (state) {
                return state.pinnedMessageSummary;
              },
              builder: (context, pinnedMessageSummary) {
                final summary = pinnedMessageSummary;

                if (summary == null || !summary.hasPinnedMessages) {
                  return const SizedBox();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: PinnedMessageSection(pinnedMessageSummary: summary),
                );
              },
            ),
            Expanded(child: ChatContent()),
            BlocSelector<WSDetailBloc, WSDetailState, MessageReply?>(
              selector: (state) {
                return state.messageReply;
              },
              builder: (context, messageReply) {
                return ChatInputBar(
                  messageReply: messageReply,
                  onReplyClose: () {
                    bloc.add(CloseReplyMessageEvent());
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
