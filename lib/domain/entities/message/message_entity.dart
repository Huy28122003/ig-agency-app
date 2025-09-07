import 'package:equatable/equatable.dart';

import '../../enums/message_enums.dart';
import 'message_content.dart';
import 'message_reply.dart';
import 'message_sender.dart';

class MessageEntity extends Equatable {
  const MessageEntity({
    this.id,
    required this.tempId,
    required this.sender,
    required this.createdAt,
    required this.type,
    required this.content,
    required this.status,
    this.workspaceId,
    this.groupName,
    this.reply,
    this.isPinned = false,
    this.pinnedAt,
  });

  bool get isText => type == MessageType.text && content is TextMessageContent;

  bool get isImage =>
      type == MessageType.image && content is ImageMessageContent;

  bool get isVideo =>
      type == MessageType.video && content is VideoMessageContent;

  bool get isFile => type == MessageType.file && content is FileMessageContent;

  bool get isSystem =>
      type == MessageType.system && content is SystemMessageContent;

  final String? id;
  final String tempId;
  final MessageSender sender;
  final DateTime createdAt;
  final MessageType type;
  final MessageContent content;
  final MessageStatus status;
  final int? workspaceId;
  final String? groupName;
  final MessageReply? reply;
  final bool isPinned;
  final DateTime? pinnedAt;

  MessageEntity copyWith({
    String? id,
    String? tempId,
    MessageSender? sender,
    DateTime? createdAt,
    MessageType? type,
    MessageContent? content,
    MessageStatus? status,
    int? workspaceId,
    String? groupName,
    MessageReply? reply,
    bool? isPinned,
    DateTime? pinnedAt,
  }) => MessageEntity(
    id: id ?? this.id,
    tempId: tempId ?? this.tempId,
    sender: sender ?? this.sender,
    createdAt: createdAt ?? this.createdAt,
    type: type ?? this.type,
    content: content ?? this.content,
    status: status ?? this.status,
    workspaceId: workspaceId ?? this.workspaceId,
    groupName: groupName ?? this.groupName,
    reply: reply ?? reply,
    isPinned: isPinned ?? this.isPinned,
    pinnedAt: pinnedAt ?? this.pinnedAt,
  );

  @override
  List<Object?> get props => [
    id,
    tempId,
    sender,
    createdAt,
    type,
    content,
    status,
    workspaceId,
    groupName,
    reply,
    isPinned,
    pinnedAt,
  ];
}
