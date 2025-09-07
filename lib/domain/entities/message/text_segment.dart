import 'package:equatable/equatable.dart';
import '../../enums/message_enums.dart';

class TextSegment extends Equatable {
  final TextSegmentType type;
  final int start;
  final int end;
  final dynamic extra;

  const TextSegment({
    this.type = TextSegmentType.normal,
    required this.start,
    required this.end,
    this.extra,
  });

  @override
  List<Object?> get props => [type, start, end, extra];
}
