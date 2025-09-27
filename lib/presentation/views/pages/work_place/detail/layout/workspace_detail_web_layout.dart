import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/work_place/detail/workspace_detail_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_button.dart';

import '../../../../../../domain/entities/message/message_entity.dart';
import '../../../../../../domain/enums/send_message_type.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../../../../../routers/app_router.dart';
import '../../../../widgets/chat_input/chat_input_bar.dart';
import '../../../../widgets/circle_network_avatar.dart';
import '../widgets/chat_content.dart';

class WorkspaceDetailDesktopLayout extends StatefulWidget {
  const WorkspaceDetailDesktopLayout({super.key});

  @override
  State<WorkspaceDetailDesktopLayout> createState() =>
      _WorkspaceDetailDesktopLayoutState();
}

class _WorkspaceDetailDesktopLayoutState
    extends State<WorkspaceDetailDesktopLayout> {
  late final WSDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<WSDetailBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WSDetailBloc, WSDetailState>(
      listener: (BuildContext context, WSDetailState state) {
        if (state.showGroupInfo) {
          context.router.replace(
            GroupInfoRoute(groupId: context.read<WSDetailBloc>().groupId),
          );
        }
      },
      listenWhen: (pre, cur) => pre.showGroupInfo != cur.showGroupInfo,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: AppColors.surfaceContainerGrayStrong1,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 350,
                      constraints: BoxConstraints(minWidth: 300, maxWidth: 350),
                      child: AutoRouter(),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Scaffold(
                            resizeToAvoidBottomInset: true,
                            backgroundColor: Colors.white,
                            appBar: AppBar(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              leadingWidth: 44,
                              toolbarHeight: 60,
                              scrolledUnderElevation: 0,
                              automaticallyImplyLeading: false,
                              title: Row(
                                children: [
                                  CircleNetworkAvatar(
                                    imageUrl: 'https://example.com/avatar.jpg',
                                    size: 40,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Whales - IG Agency 8%',
                                          style: TextStyle(
                                            color: AppColors
                                                .textDefaultTextDefault,
                                            fontSize: 16,
                                            fontFamily: FontFamily.segoeUI,
                                            fontWeight: FontWeight.w700,
                                            height: 1.50,
                                          ),
                                        ),
                                        Text(
                                          '99 Members, 29 Online',
                                          style: TextStyle(
                                            color:
                                                AppColors.textDefaultTextSub2,
                                            fontSize: 14,
                                            fontFamily: FontFamily.segoeUI,
                                            fontWeight: FontWeight.w400,
                                            height: 1.14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AppButton.icon(
                                    onPressed: () {
                                      _bloc.add(OnShowGroupInfoEvent());
                                    },
                                    icon: Assets.icons.icInfo.svg(),
                                  ),
                                ],
                              ),
                            ),
                            body: SafeArea(
                              child: Column(
                                children: [
                                  Expanded(child: ChatContent()),
                                  BlocSelector<
                                    WSDetailBloc,
                                    WSDetailState,
                                    MessageEntity?
                                  >(
                                    selector: (state) {
                                      return state.messageReply;
                                    },
                                    builder: (context, message) {
                                      return ChatInputBar(
                                        userId: _bloc.userId,
                                        textEditingController:
                                            _bloc.textEditingController,
                                        messageReply: message,
                                        onReplyClose: () {
                                          _bloc.add(CloseReplyMessageEvent());
                                        },
                                        onDocumentTap: () {
                                          _bloc.add(
                                            SendMessageEvent(
                                              type: SendMessageType.file,
                                            ),
                                          );
                                        },
                                        onCameraTap: () {
                                          context.router.push(CameraRoute());
                                        },
                                        onMediaTap: () {
                                          _bloc.add(
                                            SendMessageEvent(
                                              type: SendMessageType.media,
                                            ),
                                          );
                                        },
                                        onSendTap: () {
                                          _bloc.add(
                                            SendMessageEvent(
                                              type: SendMessageType.text,
                                            ),
                                          );
                                        },
                                        onToggleOptions: (showOptions) {
                                          _bloc.add(
                                            ToggleHasOptionsEvent(
                                              showOptions: showOptions,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      BlocSelector<WSDetailBloc, WSDetailState, bool>(
                        selector: (WSDetailState state) => state.showGroupInfo,
                        builder: (BuildContext context, bool showGroupInfo) {
                          return AnimatedContainer(
                            margin: EdgeInsets.only(
                              left: showGroupInfo ? 8 : 0,
                            ),
                            width: showGroupInfo ? 350 : 0,
                            constraints: BoxConstraints(
                              minWidth: showGroupInfo ? 300 : 0,
                              maxWidth: 350,
                            ),
                            duration: Duration(milliseconds: 200),
                            curve: Curves.linear,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
