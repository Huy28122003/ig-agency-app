import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/message/message.dart';
import 'package:ig_agency_app/domain/usecases/fetch_member_in_workspace_use_case.dart';
import 'package:ig_agency_app/domain/usecases/search_member_in_workspace_use_case.dart';
import 'package:ig_agency_app/presentation/views/widgets/chat_input/tag_user_list_view.dart';

import '../../../../di/di.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../shared/utils/tag_user_text_editing_controller.dart';
import '../../../resources/colors.dart';
import '../chat/reply_message_section.dart';
import 'chat_option.dart';
import 'chat_textfield.dart';
import 'cubit/chat_input_cubit.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.workspaceId,
    required this.userId,
    required this.messageReply,
    required this.onReplyClose,
    required this.onDocumentTap,
    required this.onCameraTap,
    required this.onImageTap,
    required this.onSendTap,
  });

  final int workspaceId;
  final String? userId;
  final MessageEntity? messageReply;
  final VoidCallback? onReplyClose;
  final VoidCallback? onDocumentTap;
  final VoidCallback? onCameraTap;
  final VoidCallback? onImageTap;
  final Function(String)? onSendTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatInputCubit(
        fetchMemberInWorkspaceUseCase: getIt<FetchMemberInWorkspaceUseCase>(),
        searchMemberInWorkspaceUseCase: getIt<SearchMemberInWorkspaceUseCase>(),
        workspaceId: workspaceId,
      )..fetchMembers(),
      child: _ChatInputBar(
        userId: userId,
        messageReply: messageReply,
        onReplyClose: onReplyClose,
        onDocumentTap: onDocumentTap,
        onCameraTap: onCameraTap,
        onImageTap: onImageTap,
        onSendTap: onSendTap,
      ),
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
    this.onImageTap,
    this.onSendTap,
  });

  final String? userId;
  final MessageEntity? messageReply;
  final VoidCallback? onReplyClose;
  final VoidCallback? onDocumentTap;
  final VoidCallback? onCameraTap;
  final VoidCallback? onImageTap;
  final Function(String)? onSendTap;

  @override
  State<_ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<_ChatInputBar> {
  late final ChatInputCubit _cubit;

  final FocusNode _focusNode = FocusNode();
  late final TagUserTextEditingController _textEditingController;

  OverlayEntry? _overlayEntry;
  final GlobalKey _inputKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ChatInputCubit>();
    _textEditingController = TagUserTextEditingController();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _cubit.updateHasOptions(false);
      } else {
        _cubit.updateHasOptions(true);
      }
    });

    _textEditingController.addListener(() {
      final input = _textEditingController.text;

      if (_cubit.state.hasSendButton && input.isEmpty) {
        _cubit.updateHasSendButton(false);
      } else if (!_cubit.state.hasSendButton && input.isNotEmpty) {
        _cubit.updateHasSendButton(true);
      }
    });

    _textEditingController.showMentionOverlay.listen((show) {
      if (show) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    });

    // _textEditingController.mentionQuery.listen((query) {
    //   _cubit.searchMembers(query);

    //   if (_overlayEntry != null) {
    //     _overlayEntry?.markNeedsBuild();
    //   }
    // });
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
          bottom: MediaQuery.of(context).size.height - offset.dy + 10,
          child: Material(
            color: Colors.transparent,
            child: BlocProvider.value(
              value: _cubit,
              child: BlocConsumer<ChatInputCubit, ChatInputState>(
                listenWhen: (previous, current) =>
                    previous.users != current.users,
                listener: (context, state) {
                  if (state.users.isEmpty) {
                    _hideOverlay();
                  }
                },
                buildWhen: (previous, current) =>
                    previous.users != current.users,

                builder: (context, state) {
                  if (state.users.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return TagUserListView(
                    users: state.users,
                    onTap: (user) {
                      _textEditingController.addMention(user.name, user.id);
                      _hideOverlay();
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
    _textEditingController.dispose();
    _focusNode.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = widget.messageReply;
    final bool hasReplyMessage = messageReply != null;

    return BlocListener<ChatInputCubit, ChatInputState>(
      listenWhen: (previous, current) => previous.users != current.users,
      listener: (context, state) {},
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
              spacing: 8,
              children: [
                BlocBuilder<ChatInputCubit, ChatInputState>(
                  builder: (context, state) {
                    return ChatOption(
                      hasOptions: state.hasOptions,
                      onDocumentTap: widget.onDocumentTap,
                      onCameraTap: widget.onCameraTap,
                      onImageTap: widget.onImageTap,
                    );
                  },
                ),
                Expanded(
                  child: ChatTextField(
                    key: _inputKey,
                    textEditingController: _textEditingController,
                    focusNode: _focusNode,
                    onTapOutside: () {
                      _focusNode.unfocus();
                    },
                  ),
                ),
                BlocBuilder<ChatInputCubit, ChatInputState>(
                  builder: (context, state) {
                    if (state.hasSendButton) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                          padding: EdgeInsets.all(10),
                          onPressed: () {
                            widget.onSendTap?.call(_textEditingController.text);
                            _textEditingController.clear();
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
