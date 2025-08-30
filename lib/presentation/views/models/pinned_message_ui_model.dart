import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../../../domain/entities/message/message.dart';
import '../../../shared/commons/enums/pinned_message_type.dart';

class PinnedMessageUIModel extends Equatable {
  const PinnedMessageUIModel({
    this.id,
    required this.senderName,
    required this.senderAvatarUrl,
    required this.pinnedAt,
    required this.type,
    required this.content,
    this.hostName,
    this.textSpans,
  });

  bool get isText =>
      type == PinnedMessageType.text && content is TextMessageContent;

  bool get isImage =>
      type == PinnedMessageType.image && content is ImageMessageContent;

  bool get isVideo =>
      type == PinnedMessageType.video && content is VideoMessageContent;

  bool get isFile =>
      type == PinnedMessageType.file && content is FileMessageContent;

  final String? id;
  final String senderName;
  final String senderAvatarUrl;
  final DateTime pinnedAt;
  final PinnedMessageType type;
  final MessageContent content;
  final String? hostName;
  final List<TextSpan>? textSpans;

  @override
  List<Object?> get props => [
    id,
    senderName,
    senderAvatarUrl,
    pinnedAt,
    type,
    content,
    hostName,
    textSpans,
  ];
}
