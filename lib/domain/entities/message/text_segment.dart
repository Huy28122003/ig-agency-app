import '../../enums/message_enums.dart';

class TextSegment {
  final TextSegmentType type;
  final int start;
  final int end;

  const TextSegment({
    this.type = TextSegmentType.normal,
    required this.start,
    required this.end,
  });
}
