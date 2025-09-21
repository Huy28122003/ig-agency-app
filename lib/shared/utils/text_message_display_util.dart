import 'package:flutter/widgets.dart';
import '../../domain/entities/message/message.dart';
import '../../domain/enums/message_enums.dart';
import '../../presentation/resources/colors.dart';

class TextMessageDisplayUtil {
  static (List<TextSpan>, String?, String?) parseTextContent(
    TextMessageContent textContent,
    TextStyle? textStyle, {
    TextStyle? linkStyle,
    TextStyle? tagStyle,
    TextStyle? searchStyle,
    String? searchText,
    bool caseSensitive = true,
  }) {
    final text = textContent.text;
    final textSegments = textContent.textSegments;

    if (textSegments == null || textSegments.isEmpty) {
      return ([TextSpan(text: text, style: textStyle)], null, null);
    }

    return _buildSpans(
      text,
      textSegments,
      textStyle: textStyle,
      linkStyle: linkStyle,
      tagStyle: tagStyle,
      searchStyle: searchStyle,
      searchText: searchText,
      caseSensitive: caseSensitive,
    );
  }

  static (List<TextSpan>, String?, String?) _buildSpans(
    String text,
    List<TextSegment> baseSegments, {
    TextStyle? textStyle,
    TextStyle? linkStyle,
    TextStyle? tagStyle,
    TextStyle? searchStyle,
    String? searchText,
    bool caseSensitive = true,
  }) {
    linkStyle ??= textStyle?.copyWith(decoration: TextDecoration.underline);
    tagStyle ??= textStyle?.copyWith(fontWeight: FontWeight.w700);
    searchStyle ??= textStyle?.copyWith(
      backgroundColor: AppColors.surfaceContainerGrayStrong95,
      color: AppColors.textDefaultTextInverted,
    );

    final search = searchText;
    final searchSegments = <TextSegment>[];
    if (search != null && search.isNotEmpty) {
      searchSegments.addAll(_createSearchSegments(text, search, caseSensitive));
    }

    // Case 1: Không có search text
    if (searchSegments.isEmpty) {
      return _buildSpansWithoutSearch(
        text,
        baseSegments,
        textStyle: textStyle,
        linkStyle: linkStyle,
        tagStyle: tagStyle,
      );
    }
    // Case 2: Có search text
    else {
      return _buildSpansWithSearch(
        text,
        baseSegments,
        textStyle: textStyle,
        linkStyle: linkStyle,
        tagStyle: tagStyle,
        searchStyle: searchStyle,
        searchSegments: searchSegments,
      );
    }
  }

  static (List<TextSpan>, String?, String?) _buildSpansWithoutSearch(
    String text,
    List<TextSegment> baseSegments, {
    TextStyle? textStyle,
    TextStyle? linkStyle,
    TextStyle? tagStyle,
  }) {
    final spans = <TextSpan>[];
    String? hostName;
    String? link;
    int lastIndex = 0;

    for (final ann in baseSegments) {
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
          spans.add(TextSpan(text: textPart, style: tagStyle));
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

  static (List<TextSpan>, String?, String?) _buildSpansWithSearch(
    String text,
    List<TextSegment> baseSegments, {
    TextStyle? textStyle,
    TextStyle? linkStyle,
    TextStyle? tagStyle,
    TextStyle? searchStyle,
    required List<TextSegment> searchSegments,
  }) {
    final allSegments = <TextSegment>[...baseSegments, ...searchSegments];

    // Trải dài tất cả các mốc start/end của các segment
    // để check giao giữa các segment
    final boundaries = <int>{0, text.length};
    for (final s in allSegments) {
      final sStart = s.start.clamp(0, text.length);
      final sEnd = s.end.clamp(0, text.length);
      boundaries.add(sStart);
      boundaries.add(sEnd);
    }

    final points = boundaries.toList()..sort();

    final spans = <TextSpan>[];
    String? hostName;
    String? link;

    for (var i = 0; i < points.length - 1; i++) {
      final start = points[i];
      final end = points[i + 1];
      if (start >= end) continue;

      // segment nào bao phủ toàn bộ khoảng [start,end)
      final covering = allSegments.where(
        (s) => s.start <= start && s.end >= end,
      );

      // Ưu tiên search > link || tag > normal
      final isSearch = covering.any((s) => s.type == TextSegmentType.search);
      final isLink = covering.any((s) => s.type == TextSegmentType.link);
      final isTag = covering.any((s) => s.type == TextSegmentType.tag);

      final isLinkOrTag = isLink || isTag;
      TextStyle? chosenStyle;

      // Check link đầu tiên
      if (isLink) {
        link ??= text.substring(start, end);
        print('hoannk');
        print(link);
        hostName ??= Uri.tryParse(link)?.host;
      }

      // Check text segment
      if (isSearch) {
        chosenStyle = searchStyle;
      } else if (isLinkOrTag) {
        if (isLink) {
          chosenStyle = linkStyle;
        } else if (isTag) {
          chosenStyle = tagStyle;
        }
      } else {
        chosenStyle = textStyle;
      }

      final part = text.substring(start, end);

      // Gộp span liền kề có cùng style
      if (spans.isNotEmpty && spans.last.style == chosenStyle) {
        // Xoá span cuối và thêm span mới với content là content của span cuối
        // hiện tại  và span mới
        final last = spans.removeLast();
        spans.add(TextSpan(text: '${last.text}$part', style: chosenStyle));
      } else {
        spans.add(TextSpan(text: part, style: chosenStyle));
      }
    }

    return (spans, hostName, link);
  }

  static List<TextSegment> _createSearchSegments(
    String text,
    String searchText,
    bool caseSensitive,
  ) {
    final pattern = RegExp(
      r'\b' + RegExp.escape(searchText) + r'\b',
      caseSensitive: false,
      unicode: true,
    );
    final matches = pattern.allMatches(text);
    final segments = <TextSegment>[];
    for (final match in matches) {
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

  static int calculateTextLines({
    required String text,
    required double maxWidth,
    required TextStyle style,
    int? maxLines,
  }) {
    if (maxWidth <= 0) {
      return 1;
    }

    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    final lineHeight = textPainter.preferredLineHeight;
    if (lineHeight <= 0) {
      return 1;
    }

    final lineCount = (textPainter.size.height / lineHeight).ceil();
    return lineCount;
  }
}
