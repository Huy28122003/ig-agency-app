import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/message/message.dart';
import 'package:ig_agency_app/presentation/views/pages/work_place/detail/workspace_detail_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/chat_input/tag_user_list_view.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../shared/utils/tag_user_text_editing_controller.dart';
import '../../../resources/colors.dart';
import '../chat/reply_message_section.dart';
import 'chat_option.dart';
import 'chat_textfield.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.workspaceId,
    required this.userId,
    required this.messageReply,
    required this.onReplyClose,
    required this.onDocumentTap,
    required this.onCameraTap,
    required this.onMediaTap,
    required this.onSendTap,
  });

  final int workspaceId;
  final String? userId;
  final MessageEntity? messageReply;
  final VoidCallback? onReplyClose;
  final VoidCallback? onDocumentTap;
  final VoidCallback? onCameraTap;
  final VoidCallback? onMediaTap;
  final VoidCallback? onSendTap;

  @override
  Widget build(BuildContext context) {
    return _ChatInputBar(
      userId: userId,
      messageReply: messageReply,
      onReplyClose: onReplyClose,
      onDocumentTap: onDocumentTap,
      onCameraTap: onCameraTap,
      onMediaTap: onMediaTap,
      onSendTap: onSendTap,
    );
  }
}

class _ChatInputBar extends StatefulWidget {
  const _ChatInputBar({
    this.userId,
    this.messageReply,
    this.onReplyClose,
    this.onDocumentTap,
    this.onCameraTap,
    this.onMediaTap,
    this.onSendTap,
  });

  final String? userId;
  final MessageEntity? messageReply;
  final VoidCallback? onReplyClose;
  final VoidCallback? onDocumentTap;
  final VoidCallback? onCameraTap;
  final VoidCallback? onMediaTap;
  final VoidCallback? onSendTap;

  @override
  State<_ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<_ChatInputBar> {
  late final WSDetailBloc _bloc;

  final FocusNode _focusNode = FocusNode();
  late final TagUserTextEditingController _textEditingController;

  OverlayEntry? _overlayEntry;
  final GlobalKey _inputKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _bloc = context.read<WSDetailBloc>();
    _textEditingController = _bloc.textEditingController;
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final RenderBox? renderBox =
        _inputKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      return;
    }

    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).size.height - offset.dy,
          child: Material(
            color: Colors.transparent,
            child: BlocProvider.value(
              value: _bloc,
              child: BlocBuilder<WSDetailBloc, WSDetailState>(
                buildWhen: (previous, current) =>
                    previous.users != current.users,
                builder: (context, state) {
                  if (state.users.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return TagUserListView(
                    users: state.users,
                    onTap: (user) {
                      _textEditingController.addTag(user.name, user.id);
                      _focusNode.requestFocus();
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    if (mounted) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = widget.messageReply;
    final bool hasReplyMessage = messageReply != null;

    return BlocListener<WSDetailBloc, WSDetailState>(
      listenWhen: (previous, current) =>
          previous.users != current.users ||
          previous.showTagOverlay != current.showTagOverlay,
      listener: (context, state) {
        if (state.showTagOverlay) {
          _showOverlay();
        } else if (!state.showTagOverlay) {
          _hideOverlay();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasReplyMessage)
            ReplyMessageSection(
              messageReply: messageReply,
              isMe: widget.userId == messageReply.sender.id,
              onClose: widget.onReplyClose,
            ),
          Container(
            key: _inputKey,
            padding: const EdgeInsets.symmetric(vertical: 10),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerGrayStrong0,
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: AppColors.outlineGrayStrong200,
                ),
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
                      previous.hasOptions != current.hasOptions,
                  builder: (context, state) {
                    return ChatOption(
                      hasOptions: state.hasOptions,
                      onDocumentTap: widget.onDocumentTap,
                      onCameraTap: widget.onCameraTap,
                      onMediaTap: widget.onMediaTap,
                    );
                  },
                ),
                Expanded(
                  child: ChatTextField(
                    textEditingController: _textEditingController,
                    focusNode: _focusNode,
                  ),
                ),
                BlocBuilder<WSDetailBloc, WSDetailState>(
                  buildWhen: (previous, current) =>
                      previous.hasSendButton != current.hasSendButton,
                  builder: (context, state) {
                    if (state.hasSendButton) {
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
      ),
    );
  }
}
