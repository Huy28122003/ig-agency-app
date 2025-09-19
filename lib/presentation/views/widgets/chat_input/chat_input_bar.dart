import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/message/message.dart';
import 'package:ig_agency_app/presentation/views/pages/work_place/detail/workspace_detail_bloc.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../shared/utils/tag_user_text_editing_controller.dart';
import '../../../resources/colors.dart';
import '../chat/reply_message_section.dart';
import 'chat_option.dart';
import 'chat_textfield.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.textEditingController,
    this.focusNode,
    this.userId,
    this.messageReply,
    this.onReplyClose,
    this.onDocumentTap,
    this.onCameraTap,
    this.onMediaTap,
    this.onSendTap,
    this.onToggleOptions,
  });

  final String? userId;
  final FocusNode? focusNode;
  final TagUserTextEditingController textEditingController;
  final MessageEntity? messageReply;
  final VoidCallback? onReplyClose;
  final VoidCallback? onDocumentTap;
  final VoidCallback? onCameraTap;
  final VoidCallback? onMediaTap;
  final VoidCallback? onSendTap;
  final Function(bool showOptions)? onToggleOptions;

  @override
  Widget build(BuildContext context) {
    return _ChatInputBar(
      textEditingController: textEditingController,
      userId: userId,
      focusNode: focusNode,
      messageReply: messageReply,
      onReplyClose: onReplyClose,
      onDocumentTap: onDocumentTap,
      onCameraTap: onCameraTap,
      onMediaTap: onMediaTap,
      onSendTap: onSendTap,
      onToggleOptions: onToggleOptions,
    );
  }
}

class _ChatInputBar extends StatefulWidget {
  const _ChatInputBar({
    this.userId,
    this.focusNode,
    this.textEditingController,
    this.messageReply,
    this.onReplyClose,
    this.onDocumentTap,
    this.onCameraTap,
    this.onMediaTap,
    this.onSendTap,
    this.onToggleOptions,
  });

  final String? userId;
  final FocusNode? focusNode;
  final TagUserTextEditingController? textEditingController;
  final MessageEntity? messageReply;
  final VoidCallback? onReplyClose;
  final VoidCallback? onDocumentTap;
  final VoidCallback? onCameraTap;
  final VoidCallback? onMediaTap;
  final VoidCallback? onSendTap;
  final Function(bool showOptions)? onToggleOptions;

  @override
  State<_ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<_ChatInputBar> {
  late final TagUserTextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController =
        widget.textEditingController ?? TagUserTextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = widget.messageReply;
    final bool hasReplyMessage = messageReply != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasReplyMessage)
          ReplyMessageSection(
            messageReply: messageReply,
            isMe: widget.userId == messageReply.user.id,
            onClose: widget.onReplyClose,
          ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerGrayStrong0,
            border: Border(
              top: BorderSide(width: 1, color: AppColors.outlineGrayStrong200),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 4,
                offset: Offset(0, -2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 8,
            children: [
              BlocBuilder<WSDetailBloc, WSDetailState>(
                buildWhen: (previous, current) =>
                    previous.showOptions != current.showOptions,
                builder: (context, state) {
                  return ChatOption(
                    hasOptions: state.showOptions,
                    onDocumentTap: widget.onDocumentTap,
                    onCameraTap: widget.onCameraTap,
                    onMediaTap: widget.onMediaTap,
                    onToggleOptions: () => widget.onToggleOptions?.call(true),
                  );
                },
              ),
              Expanded(
                child: ChatTextField(
                  focusNode: widget.focusNode,
                  textEditingController: _textEditingController,
                  onToggleOptions: widget.onToggleOptions,
                ),
              ),
              BlocBuilder<WSDetailBloc, WSDetailState>(
                buildWhen: (previous, current) =>
                    previous.showSendButton != current.showSendButton,
                builder: (context, state) {
                  if (state.showSendButton) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        padding: EdgeInsets.all(10),
                        onPressed: () {
                          widget.onSendTap?.call();
                        },
                        icon: Assets.icons.icSend.svg(width: 24, height: 24),
                      ),
                    );
                  }
                  return const SizedBox(width: 12);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
