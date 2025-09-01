import 'package:flutter/widgets.dart';

import '../../domain/entities/message/message.dart';
import '../../domain/enums/message_enums.dart';

class TextMessageDisplayUtil {
  static (List<TextSpan>, String?) parseTextContent(
    MessageContent content,
    TextStyle? textStyle, {
    TextStyle? linkStyle,
    TextStyle? mentionStyle,
  }) {
    final textContent = content as TextMessageContent;

    if (textContent.textSegments != null &&
        textContent.textSegments!.isNotEmpty) {
      return _handleTextSegments(
        textContent.text,
        textContent.textSegments!,
        textStyle: textStyle,
        linkStyle: linkStyle,
        mentionStyle: mentionStyle,
      );
    } else {
      return ([TextSpan(text: textContent.text, style: textStyle)], null);
    }
  }

  static (List<TextSpan>, String?) _handleTextSegments(
    String text,
    List<TextSegment> textSegments, {
    TextStyle? textStyle,
    TextStyle? linkStyle,
    TextStyle? mentionStyle,
  }) {
    textSegments.sort((a, b) => a.start.compareTo(b.start));
    final spans = <TextSpan>[];
    String? hostName;

    int lastIndex = 0;

    linkStyle ??= textStyle?.copyWith(decoration: TextDecoration.underline);
    mentionStyle ?? textStyle?.copyWith(fontWeight: FontWeight.w700);

    for (final ann in textSegments) {
      if (ann.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, ann.start),
            style: textStyle,
          ),
        );
      }

      final textPart = text.substring(ann.start, ann.end);

      switch (ann.type) {
        case TextSegmentType.link:
          spans.add(TextSpan(text: textPart, style: linkStyle));
          hostName = Uri.tryParse(textPart)?.host;
          break;
        case TextSegmentType.mention:
          spans.add(TextSpan(text: textPart, style: mentionStyle));
          break;
        default:
          spans.add(TextSpan(text: textPart, style: textStyle));
      }

      lastIndex = ann.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex), style: textStyle));
    }

    return (spans, hostName);
  }
}
