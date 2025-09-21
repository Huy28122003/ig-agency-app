import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/work_place/detail/workspace_detail_bloc.dart';

import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/chat_bubble/chat_message_bubble.dart';

class GroupRemovedView extends StatelessWidget {
  const GroupRemovedView({super.key, required this.bloc, this.isMobile = true});

  final WSDetailBloc bloc;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return BlocListener<WSDetailBloc, WSDetailState>(
      listenWhen: (previous, current) =>
          previous.isDeletedConversationSuccess !=
          current.isDeletedConversationSuccess,
      listener: (context, state) {
        if (state.isDeletedConversationSuccess) {
          context.router.pop();
        }
      },
      child: SafeArea(
        child: Column(
          spacing: 20,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: BlocBuilder<WSDetailBloc, WSDetailState>(
                  buildWhen: (previous, current) =>
                      previous.chatMessages != current.chatMessages,
                  builder: (context, state) {
                    return state.chatMessages.isEmpty
                        ? const SizedBox.shrink()
                        : ChatMessageBubble.system(
                            message: state.chatMessages.first.message,
                            shouldShowTime: true,
                          );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: AppColors.outlineGrayStrong200,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 12,
                children: [
                  _buildContent(),
                  AppButton.primary(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: AppColors.surfaceContainerAlertError,
                    onPressed: () {
                      bloc.add(DeleteConversationEvent());
                    },
                    child: Text(
                      'Delete conversation',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textDefaultTextInverted,
                        fontSize: 16,
                        fontFamily: FontFamily.segoeUI,
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'You can’t message this group',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textAlertTextError,
            fontSize: 13,
            fontFamily: FontFamily.segoeUI,
            fontWeight: FontWeight.w600,
            height: 1.23,
          ),
        ),
        Text(
          'You’re no longer in this group and can’t send or receive calls or messages unless you are added back to it.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textDefaultTextSub2,
            fontSize: 12,
            fontFamily: FontFamily.segoeUI,
            fontWeight: FontWeight.w400,
            height: 1.33,
          ),
        ),
      ],
    );
  }
}
