import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

@freezed
class MessageSummary with _$MessageSummary {
  MessageSummary({required this.id, required this.message});

  @override
  final int id;
  @override
  final String message;
}
