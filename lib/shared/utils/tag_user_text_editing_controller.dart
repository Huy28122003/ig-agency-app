import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/enums/message_enums.dart';
import '../../domain/entities/message/text_segment.dart';
import '../../presentation/resources/colors.dart';

class _UserTagData {
  final String id;
  final String username;
  final String userId;
  final int start;
  final int end;

  _UserTagData({
    required this.id,
    required this.username,
    required this.userId,
    required this.start,
    required this.end,
  });

  _UserTagData copyWith({int? start, int? end}) {
    return _UserTagData(
      id: id,
      username: username,
      userId: userId,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  TextSegment toTagTextSegment() {
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

  final List<_UserTagData> _tags = [];
  String _previousText = '';

  final _showTagOverlayController = StreamController<bool>.broadcast();
  Stream<bool> get showTagOverlay => _showTagOverlayController.stream;

  final _tagQueryController = StreamController<String>.broadcast();
  Stream<String> get tagQuery => _tagQueryController.stream;
  var latestShowTagOverlay = false;

  Timer? _debounceTimer;

  @override
  void dispose() {
    removeListener(_onTextChanged);
    _showTagOverlayController.close();
    _tagQueryController.close();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    final newText = value.text;
    final cursorPosition = value.selection.baseOffset;
    final oldText = _previousText;
    _previousText = newText;

    _adjustAndCleanTags(oldText, newText);

    String? currentQuery;
    bool shouldShowOverlay = false;

    final atSignIndex = cursorPosition == 0
        ? -1
        : newText.lastIndexOf('@', cursorPosition - 1);
    if (atSignIndex != -1) {
      final potentialQuery = newText.substring(atSignIndex, cursorPosition);

      bool isInsideExistingTag = false;
      for (final tag in _tags) {
        if (cursorPosition > tag.start && cursorPosition <= tag.end) {
          isInsideExistingTag = true;
          break;
        }
      }

      if (!isInsideExistingTag) {
        final spaceAfterAt = potentialQuery.indexOf(' ', 1);
        final newlineAfterAt = potentialQuery.indexOf('\n', 1);

        final bool hasSpaceBeforeAt =
            atSignIndex == 0 ||
            (atSignIndex > 0 && newText[atSignIndex - 1] == ' ');

        if (spaceAfterAt == -1 && newlineAfterAt == -1 && hasSpaceBeforeAt) {
          currentQuery = potentialQuery.substring(1);
          shouldShowOverlay = true;
        }
      }
    }

    if (shouldShowOverlay &&
        currentQuery != null &&
        currentQuery.trim().isNotEmpty) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        _tagQueryController.add(currentQuery!);
      });
    } else {
      _debounceTimer?.cancel();
    }

    if (latestShowTagOverlay != shouldShowOverlay) {
      latestShowTagOverlay = shouldShowOverlay;
      _showTagOverlayController.add(shouldShowOverlay);
    }
  }

  void _adjustAndCleanTags(String oldText, String newText) {
    if (oldText == newText) return;

    final int oldLength = oldText.length;
    final int newLength = newText.length;

    int commonPrefix = 0;
    while (commonPrefix < oldLength &&
        commonPrefix < newLength &&
        oldText.codeUnitAt(commonPrefix) == newText.codeUnitAt(commonPrefix)) {
      commonPrefix++;
    }

    int commonSuffix = 0;
    while (commonSuffix < oldLength &&
        commonSuffix < newLength &&
        oldText.codeUnitAt(oldLength - 1 - commonSuffix) ==
            newText.codeUnitAt(newLength - 1 - commonSuffix) &&
        (oldLength - 1 - commonSuffix) >= commonPrefix &&
        (newLength - 1 - commonSuffix) >= commonPrefix) {
      commonSuffix++;
    }

    final int oldEditedStart = commonPrefix;
    final int oldEditedEnd = oldLength - commonSuffix;
    final int newEditedEnd = newLength - commonSuffix;

    final int lengthChange = newEditedEnd - oldEditedEnd;

    final List<_UserTagData> updatedTags = [];
    for (var tag in _tags) {
      if (tag.end <= oldEditedStart) {
        updatedTags.add(tag);
      } else if (tag.start >= oldEditedEnd) {
        tag = tag.copyWith(
          start: tag.start + lengthChange,
          end: tag.end + lengthChange,
        );
        updatedTags.add(tag);
      }
    }

    final tags = updatedTags;
    tags.removeWhere(
      (tag) =>
          tag.start < 0 ||
          tag.end > newText.length ||
          tag.start >= tag.end ||
          newText.substring(tag.start, tag.end) != '@${tag.username}',
    );

    _tags
      ..clear()
      ..addAll(tags);
  }

  void addTag(String username, String userId) {
    _showTagOverlayController.add(false);

    final currentText = value.text;
    final cursorPosition = value.selection.baseOffset;

    final atSignIndex = currentText.lastIndexOf('@', cursorPosition - 1);
    if (atSignIndex == -1) {
      return;
    }

    final String tagText = '@$username';
    final String newId =
        'tag-$username-${DateTime.now().millisecondsSinceEpoch}';

    final String newTextBeforeQuery = currentText.substring(0, atSignIndex);
    final String newTextAfterQuery = currentText.substring(cursorPosition);

    final String finalNewText =
        '$newTextBeforeQuery$tagText $newTextAfterQuery';

    value = TextEditingValue(
      text: finalNewText,
      selection: TextSelection.collapsed(
        offset: newTextBeforeQuery.length + tagText.length + 1,
      ),
    );

    final newTag = _UserTagData(
      id: newId,
      username: username,
      userId: userId,
      start: newTextBeforeQuery.length,
      end: newTextBeforeQuery.length + tagText.length,
    );
    _tags.add(newTag);

    final int diff = (tagText.length + 1) - (cursorPosition - atSignIndex);
    for (var tag in _tags) {
      if (tag.id != newTag.id && tag.start >= newTag.start) {
        tag = tag.copyWith(start: tag.start + diff, end: tag.end + diff);
      }
    }
  }

  void closeTagOverlay() {
    if (_showTagOverlayController.isClosed || !latestShowTagOverlay) return;
    _showTagOverlayController.add(false);
  }

  List<TextSegment> get tagTextSegments {
    return _tags.map((e) => e.toTagTextSegment()).toList();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<TextSpan> children = [];
    int currentPosition = 0;

    _tags.sort((a, b) => a.start.compareTo(b.start));

    for (final tag in _tags) {
      if (tag.start > currentPosition) {
        children.add(
          TextSpan(
            text: text.substring(currentPosition, tag.start),
            style: style,
          ),
        );
      }

      children.add(
        TextSpan(
          text: text.substring(tag.start, tag.end),
          style: style?.copyWith(color: AppColors.textAlertTextInfo),
        ),
      );
      currentPosition = tag.end;
    }

    if (currentPosition < text.length) {
      children.add(
        TextSpan(text: text.substring(currentPosition), style: style),
      );
    }

    return TextSpan(style: style, children: children);
  }
}
