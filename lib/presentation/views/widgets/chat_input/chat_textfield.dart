import 'package:flutter/material.dart';

import '../../../../gen/fonts.gen.dart';
import '../../../../shared/utils/tag_user_text_editing_controller.dart';
import '../../../resources/colors.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField({
    super.key,
    this.focusNode,
    required this.textEditingController,
    this.onToggleOptions,
  });

  final FocusNode? focusNode;
  final TagUserTextEditingController textEditingController;
  final Function(bool showOptions)? onToggleOptions;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      constraints: BoxConstraints(maxHeight: 120),
      decoration: ShapeDecoration(
        color: AppColors.surfaceContainerGrayStrong2,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.outlineGrayStrong200),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(22),
            right: Radius.circular(22),
          ),
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
        onTap: () => onToggleOptions?.call(false),
        focusNode: focusNode,
        controller: textEditingController,
        maxLines: null,
        minLines: 1,
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
