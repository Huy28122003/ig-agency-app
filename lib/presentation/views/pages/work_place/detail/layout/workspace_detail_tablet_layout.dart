import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/work_place/detail/workspace_detail_bloc.dart';

import '../../../../../../domain/entities/message/message_entity.dart';
import '../../../../../../domain/enums/send_message_type.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../../../../widgets/chat_input/chat_input_bar.dart';
import '../../../../widgets/circle_network_avatar.dart';
import '../widgets/chat_content.dart';

class WorkspaceDetailTabletLayout extends StatefulWidget {
  const WorkspaceDetailTabletLayout({super.key});

  @override
  State<WorkspaceDetailTabletLayout> createState() =>
      _WorkspaceDetailTabletLayoutState();
}

class _WorkspaceDetailTabletLayoutState
    extends State<WorkspaceDetailTabletLayout> {
  late final WSDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<WSDetailBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 44,
        toolbarHeight: 60,
        scrolledUnderElevation: 0,
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
            Expanded(child: ChatContent()),
            BlocSelector<WSDetailBloc, WSDetailState, MessageEntity?>(
              selector: (state) {
                return state.messageReply;
              },
              builder: (context, message) {
                return ChatInputBar(
                  workspaceId: _bloc.workspaceId,
                  userId: _bloc.userId,
                  messageReply: message,
                  onReplyClose: () {
                    _bloc.add(CloseReplyMessageEvent());
                  },
                  onDocumentTap: () {
                    // TODO hoannk:
                  },
                  onCameraTap: () {
                    // TODO hoannk:
                  },
                  onMediaTap: () {
                    _bloc.add(SendMessageEvent(type: SendMessageType.media));
                  },
                  onSendTap: () {
                    _bloc.add(SendMessageEvent(type: SendMessageType.text));
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
