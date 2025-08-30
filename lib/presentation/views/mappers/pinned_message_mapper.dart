import 'package:flutter/widgets.dart';

import '../../../domain/entities/message/message.dart';
import '../../../domain/enums/message_enums.dart';
import '../../../gen/fonts.gen.dart';
import '../../../shared/commons/enums/pinned_message_type.dart';
import '../../../shared/utils/text_parser.dart';
import '../../resources/colors.dart';
import '../models/pinned_message_ui_model.dart';

class PinnedMessageMapper {
  static final TextStyle _textStyle = const TextStyle(
    color: AppColors.textDefaultTextDefault,
    fontSize: 16,
    fontFamily: FontFamily.segoeUI,
    fontWeight: FontWeight.w400,
    height: 1.50,
  );

  static PinnedMessageUIModel fromMessageEntity(MessageEntity entity) {
    if (entity.isText) {
      final textContent = entity.content as TextMessageContent;

      List<TextSpan> textSpans = [];
      String? hostName;

      if (textContent.textSegments != null &&
          textContent.textSegments!.isNotEmpty) {
        final textParserResult = TextParser.parseText(
          textContent.text,
          textContent.textSegments!,
          textStyle: _textStyle,
        );
        textSpans = textParserResult.$1;
        hostName = textParserResult.$2;
      } else {
        textSpans = [TextSpan(text: textContent.text, style: _textStyle)];
      }
      return PinnedMessageUIModel(
        id: entity.id,
        senderName: entity.sender.name,
        senderAvatarUrl: entity.sender.avatarUrl,
        pinnedAt: entity.pinnedAt ?? DateTime.now(),
        type: PinnedMessageType.text,
        content: entity.content,
        textSpans: textSpans,
        hostName: hostName,
      );
    }

    return PinnedMessageUIModel(
      id: entity.id,
      senderName: entity.sender.name,
      senderAvatarUrl: entity.sender.avatarUrl,
      pinnedAt: entity.pinnedAt ?? DateTime.now(),
      type: switch (entity.type) {
        MessageType.image => PinnedMessageType.image,
        MessageType.video => PinnedMessageType.video,
        MessageType.file => PinnedMessageType.file,
        _ => PinnedMessageType.text,
      },
      content: entity.content,
    );
  }
}
