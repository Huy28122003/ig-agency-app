import 'package:equatable/equatable.dart';
import '../../enums/message_enums.dart';

class TextSegment extends Equatable {
  final TextSegmentType type;
  final int start;
  final int end;

  const TextSegment({
    this.type = TextSegmentType.normal,
    required this.start,
    required this.end,
  });

  @override
  List<Object?> get props => [type, start, end];
}
