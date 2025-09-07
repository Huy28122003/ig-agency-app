import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/enums/message_enums.dart';
import '../../domain/entities/message/text_segment.dart';
import '../../presentation/resources/colors.dart';

class _UserTagData {
  final String username;
  final String userId;
  int start;
  int end;

  _UserTagData({
    required this.username,
    required this.userId,
    required this.start,
    required this.end,
  });

  TextSegment toTextSegment() {
    return TextSegment(
      type: TextSegmentType.tag,
      start: start,
      end: end,
      extra: userId,
    );
  }
}

class TagUserTextEditingController extends TextEditingController {
  TagUserTextEditingController({super.text}) {
    addListener(_onTextChanged);
  }

  final List<_UserTagData> _mentions = [];
  List<_UserTagData> _lastMentions = [];

  final _showMentionOverlayController = StreamController<bool>.broadcast();
  Stream<bool> get showMentionOverlay => _showMentionOverlayController.stream;

  final _mentionQueryController = StreamController<String>.broadcast();
  Stream<String> get mentionQuery => _mentionQueryController.stream;

  Timer? _debounceTimer;

  @override
  void dispose() {
    removeListener(_onTextChanged);
    _showMentionOverlayController.close();
    _mentionQueryController.close();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    final newText = value.text;
    final cursorPosition = value.selection.baseOffset;

    _lastMentions = List.from(_mentions);
    _mentions.clear();

    final RegExp mentionPattern = RegExp(r'@([a-zA-Z0-9_]+)');
    for (final match in mentionPattern.allMatches(newText)) {
      final username = match.group(1)!;
      final mention = _lastMentions
          .where((u) => u.username == username)
          .firstOrNull;
      if (mention != null) {
        addMention(mention.username, mention.userId);
      }
    }

    String? currentQuery;
    bool shouldShowOverlay = false;

    if (cursorPosition > 0) {
      final textBeforeCursor = newText.substring(0, cursorPosition);
      final lastAtIndex = textBeforeCursor.lastIndexOf('@');

      if (lastAtIndex != -1) {
        final potentialQuery = textBeforeCursor.substring(lastAtIndex + 1);
        if (potentialQuery.isNotEmpty && !potentialQuery.contains(' ')) {
          currentQuery = potentialQuery;
          shouldShowOverlay = true;
        } else if (potentialQuery.isEmpty) {
          shouldShowOverlay = true;
        }
      }
    }

    _showMentionOverlayController.add(shouldShowOverlay);
    if (shouldShowOverlay) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        _mentionQueryController.add(currentQuery ?? '');
      });
    }
  }

  void addMention(String username, String userId) {
    final currentText = value.text;
    final cursorPosition = value.selection.baseOffset;

    final textBeforeCursor = currentText.substring(0, cursorPosition);
    final lastAtIndex = textBeforeCursor.lastIndexOf('@');

    if (lastAtIndex != -1) {
      final prefixText = currentText.substring(0, lastAtIndex);
      final suffixText = currentText.substring(cursorPosition);
      final mentionText = '@$username';

      final newText =
          '$prefixText$mentionText $suffixText'; // add space after mention
      final newCursorPosition = lastAtIndex + mentionText.length + 1;

      value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newCursorPosition),
      );

      _mentions.add(
        _UserTagData(
          username: username,
          userId: userId,
          start: lastAtIndex,
          end: lastAtIndex + mentionText.length,
        ),
      );
    }
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<TextSpan> children = [];
    int currentPosition = 0;

    _mentions.sort((a, b) => a.start.compareTo(b.start));

    for (final mention in _mentions) {
      if (mention.start > currentPosition) {
        children.add(
          TextSpan(
            text: text.substring(currentPosition, mention.start),
            style: style,
          ),
        );
      }

      children.add(
        TextSpan(
          text: text.substring(mention.start, mention.end),
          style: style?.copyWith(color: AppColors.textAlertTextInfo),
        ),
      );
      currentPosition = mention.end;
    }

    if (currentPosition < text.length) {
      children.add(
        TextSpan(text: text.substring(currentPosition), style: style),
      );
    }

    return TextSpan(style: style, children: children);
  }

  List<TextSegment> getMentionTextSegments() {
    return _mentions.map((m) => m.toTextSegment()).toList();
  }
}
