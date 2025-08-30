import 'package:flutter/widgets.dart';

import '../../domain/entities/message/message.dart';
import '../../domain/enums/message_enums.dart';

class TextParser {
  static (List<TextSpan>, String?) parseText(
    String text,
    List<TextSegment> textSegments, {
    TextStyle? textStyle,
  }) {
    textSegments.sort((a, b) => a.start.compareTo(b.start));
    final spans = <TextSpan>[];
    String? hostName;

    int lastIndex = 0;

    final linkStyle = textStyle?.copyWith(decoration: TextDecoration.underline);
    final mentionStyle = textStyle?.copyWith(fontWeight: FontWeight.w700);

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
