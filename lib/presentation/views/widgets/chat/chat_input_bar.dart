import 'package:flutter/material.dart';
import 'package:ig_agency_app/domain/entities/message/message.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../resources/colors.dart';
import 'reply_message_section.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
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
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final ValueNotifier<bool> _hasOptions = ValueNotifier(false);
  final ValueNotifier<bool> _hasSendButton = ValueNotifier(false);

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _hasOptions.value = false;
      } else {
        _hasOptions.value = true;
      }
    });

    _textEditingController.addListener(() {
      final input = _textEditingController.text;

      if (_hasSendButton.value && input.isEmpty) {
        _hasSendButton.value = false;
      } else if (!_hasSendButton.value && input.isNotEmpty) {
        _hasSendButton.value = true;
      }
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
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
            isMe: widget.userId == messageReply.sender.id,
            onClose: widget.onReplyClose,
          ),
        Container(
          height: 64,
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
            children: [
              ValueListenableBuilder(
                valueListenable: _hasOptions,
                builder: (context, hasOptions, child) {
                  if (hasOptions) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: _OptionsBar(
                        onDocumentTap: widget.onDocumentTap,
                        onCameraTap: widget.onCameraTap,
                        onImageTap: widget.onImageTap,
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      padding: EdgeInsets.all(10),
                      onPressed: () {},
                      icon: RotatedBox(
                        quarterTurns: 2,
                        child: Assets.icons.icArrowLeft.svg(
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            AppColors.textDefaultTextDefault,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Expanded(
                child: _InputBar(textEditingController: _textEditingController),
              ),
              ValueListenableBuilder(
                valueListenable: _hasSendButton,
                builder: (context, hasSendButton, child) {
                  if (hasSendButton) {
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
    );
  }
}

class _OptionsBar extends StatelessWidget {
  const _OptionsBar({this.onDocumentTap, this.onCameraTap, this.onImageTap});
  final VoidCallback? onDocumentTap;
  final VoidCallback? onCameraTap;
  final VoidCallback? onImageTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onDocumentTap,
          child: SizedBox(
            height: 44,
            width: 44,
            child: Assets.icons.icDocumentPrimary.svg(width: 24, height: 24),
          ),
        ),
        GestureDetector(
          onTap: onCameraTap,
          child: SizedBox(
            height: 44,
            width: 44,
            child: Assets.icons.icCameraPrimary.svg(width: 24, height: 24),
          ),
        ),
        GestureDetector(
          onTap: onImageTap,
          child: SizedBox(
            height: 44,
            width: 44,
            child: Assets.icons.icAlbumPrimary.svg(width: 24, height: 24),
          ),
        ),
      ],
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({required this.textEditingController});

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: AppColors.surfaceContainerGrayStrong2,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.outlineGrayStrong200),
          borderRadius: BorderRadius.circular(9999),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x1970B250),
            blurRadius: 6.50,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextFormField(
        controller: textEditingController,
        maxLines: 1,
        style: TextStyle(
          color: AppColors.textDefaultTextSub2,
          fontSize: 16,
          fontFamily: FontFamily.segoeUI,
          fontWeight: FontWeight.w600,
          height: 1.50,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Aa',
          hintStyle: TextStyle(
            color: AppColors.textDefaultTextSub2,
            fontSize: 16,
            fontFamily: FontFamily.segoeUI,
            fontWeight: FontWeight.w600,
            height: 1.50,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }
}
