import 'package:flutter/widgets.dart';

import '../../domain/entities/message/message.dart';
import '../../domain/enums/message_enums.dart';
import '../../presentation/resources/colors.dart';

class TextMessageDisplayUtil {
  static (List<TextSpan>, String?, String?) parseTextContent(
    MessageContent content,
    TextStyle? textStyle, {
    TextStyle? linkStyle,
    TextStyle? mentionStyle,
    TextStyle? searchStyle,
    String? searchText,
    bool caseSensitive = true,
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
        searchStyle: searchStyle,
        searchText: searchText,
        caseSensitive: caseSensitive,
      );
    } else {
      return ([TextSpan(text: textContent.text, style: textStyle)], null, null);
    }
  }

  static (List<TextSpan>, String?, String?) _handleTextSegments(
    String text,
    List<TextSegment> textSegments, {
    TextStyle? textStyle,
    TextStyle? linkStyle,
    TextStyle? mentionStyle,
    TextStyle? searchStyle,
    String? searchText,
    bool caseSensitive = true,
  }) {
    List<TextSegment> allSegments = List.from(textSegments);

    if (searchText != null && searchText.isNotEmpty) {
      final searchSegments = _createSearchSegments(
        text,
        searchText,
        caseSensitive,
      );
      allSegments.addAll(searchSegments);
    }

    allSegments = _handleSegments(allSegments)
      ..sort((a, b) => a.start.compareTo(b.start));

    final spans = <TextSpan>[];
    String? hostName;
    String? link;

    int lastIndex = 0;

    linkStyle ??= textStyle?.copyWith(decoration: TextDecoration.underline);
    mentionStyle ??= textStyle?.copyWith(fontWeight: FontWeight.w700);
    searchStyle ??= textStyle?.copyWith(
      backgroundColor: AppColors.surfaceContainerGrayStrong95,
      color: AppColors.textDefaultTextInverted,
    );

    for (final ann in allSegments) {
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
          link = textPart;
          break;
        case TextSegmentType.tag:
          spans.add(TextSpan(text: textPart, style: mentionStyle));
          break;
        case TextSegmentType.search:
          spans.add(TextSpan(text: textPart, style: searchStyle));
          break;
        default:
          spans.add(TextSpan(text: textPart, style: textStyle));
      }

      lastIndex = ann.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex), style: textStyle));
    }

    return (spans, hostName, link);
  }

  static List<TextSegment> _createSearchSegments(
    String text,
    String searchText,
    bool caseSensitive,
  ) {
    final segments = <TextSegment>[];
    final escapedSearchText = RegExp.escape(searchText);
    final pattern = RegExp(escapedSearchText, caseSensitive: caseSensitive);
    for (final match in pattern.allMatches(text)) {
      segments.add(
        TextSegment(
          type: TextSegmentType.search,
          start: match.start,
          end: match.end,
        ),
      );
    }

    return segments;
  }

  static List<TextSegment> _handleSegments(List<TextSegment> segments) {
    // TODO: Handle segments
    return segments;
  }

  static int calculateTextLines({
    required String text,
    required double maxWidth,
    required TextStyle style,
    int? maxLines,
  }) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    final lineHeight = textPainter.preferredLineHeight;
    final lineCount = (textPainter.size.height / lineHeight).ceil();

    return lineCount;
  }
}
