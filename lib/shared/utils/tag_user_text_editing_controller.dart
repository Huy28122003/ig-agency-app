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

  /// Optimized method to find common prefix using binary search for long texts
  int _findCommonPrefix(String oldText, String newText) {
    final int oldLength = oldText.length;
    final int newLength = newText.length;
    final int maxLength = oldLength < newLength ? oldLength : newLength;

    // For short texts, use simple linear search
    if (maxLength <= 100) {
      int prefix = 0;
      while (prefix < maxLength &&
          oldText.codeUnitAt(prefix) == newText.codeUnitAt(prefix)) {
        prefix++;
      }
      return prefix;
    }

    // For long texts, use binary search
    int left = 0, right = maxLength;
    while (left < right) {
      int mid = (left + right + 1) ~/ 2;
      bool isCommon = true;

      // Sample check every 10th character for performance
      for (int i = 0; i < mid && isCommon; i += 10) {
        if (i < mid && oldText.codeUnitAt(i) != newText.codeUnitAt(i)) {
          isCommon = false;
        }
      }

      if (isCommon) {
        left = mid;
      } else {
        right = mid - 1;
      }
    }

    // Fine-tune the result with linear search in the final range
    int result = left;
    while (result < maxLength &&
        oldText.codeUnitAt(result) == newText.codeUnitAt(result)) {
      result++;
    }

    return result;
  }

  /// Optimized method to find common suffix using binary search for long texts
  int _findCommonSuffix(String oldText, String newText, int prefix) {
    final int oldLength = oldText.length;
    final int newLength = newText.length;
    final int maxLength = oldLength < newLength ? oldLength : newLength;
    final int availableLength = maxLength - prefix;

    if (availableLength <= 0) return 0;

    // For short texts, use simple linear search
    if (availableLength <= 100) {
      int suffix = 0;
      while (suffix < availableLength &&
          oldText.codeUnitAt(oldLength - 1 - suffix) ==
              newText.codeUnitAt(newLength - 1 - suffix)) {
        suffix++;
      }
      return suffix;
    }

    // For long texts, use binary search
    int left = 0, right = availableLength;
    while (left < right) {
      int mid = (left + right + 1) ~/ 2;
      bool isCommon = true;

      // Sample check every 10th character for performance
      for (int i = 0; i < mid && isCommon; i += 10) {
        int oldIndex = oldLength - 1 - i;
        int newIndex = newLength - 1 - i;
        if (oldText.codeUnitAt(oldIndex) != newText.codeUnitAt(newIndex)) {
          isCommon = false;
        }
      }

      if (isCommon) {
        left = mid;
      } else {
        right = mid - 1;
      }
    }

    // Fine-tune the result with linear search in the final range
    int result = left;
    while (result < availableLength &&
        oldText.codeUnitAt(oldLength - 1 - result) ==
            newText.codeUnitAt(newLength - 1 - result)) {
      result++;
    }

    return result;
  }

  void _adjustAndCleanTags(String oldText, String newText) {
    if (oldText == newText) return;

    final int oldLength = oldText.length;
    final int newLength = newText.length;

    int samePrefix = _findCommonPrefix(oldText, newText);
    int sameSuffix = _findCommonSuffix(oldText, newText, samePrefix);

    final int oldEditedStart = samePrefix; // Vị trí bắt đầu edit trong text cũ
    final int oldEditedEnd =
        oldLength - sameSuffix; // Vị trí kết thúc edit trong text cũ
    final int newEditedEnd =
        newLength - sameSuffix; // Vị trí kết thúc edit trong text mới
    final int lengthChange = newEditedEnd - oldEditedEnd; // Độ dài thay đổi

    // Duyệt ngược để không bị lỗi index do sẽ xoá nếu tag không đúng
    for (int i = _tags.length - 1; i >= 0; i--) {
      final tag = _tags[i];

      // Tag trước vùng edit => giữ nguyên
      if (tag.end <= oldEditedStart) {
        continue;
      }

      // Tag sau vùng edit => điều chỉnh vị trí
      if (tag.start >= oldEditedEnd) {
        _tags[i] = tag.copyWith(
          start: tag.start + lengthChange,
          end: tag.end + lengthChange,
        );
        continue;
      }

      // Tag trong vùng edit => kiểm tra tính hợp lệ
      if (tag.start < 0 ||
          tag.end > newText.length ||
          tag.start >= tag.end ||
          newText.substring(tag.start, tag.end) != '@${tag.username}') {
        // Remove invalid tag
        _tags.removeAt(i);
      }
    }
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
