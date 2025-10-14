import 'package:equatable/equatable.dart';
import 'package:ig_agency_app/domain/entities/user_entity.dart';

import '../../enums/message_enums.dart';
import 'message_content.dart';

class MessageEntity extends Equatable {
  const MessageEntity({
    this.id,
    this.clientMessageId,
    required this.user,
    required this.createdAt,
    required this.content,
    required this.status,
    this.groupId,
    this.repliedMessage,
    this.isPinned = false,
  });

  final String? id;
  final String? clientMessageId;
  final UserEntity user;
  final DateTime createdAt;
  final MessageContent content;
  final MessageStatus status;
  final String? groupId;
  final MessageEntity? repliedMessage;
  final bool isPinned;

  bool get hasNotReply => repliedMessage == null;

  MessageEntity copyWith({
    String? id,
    String? clientMessageId,
    UserEntity? user,
    DateTime? createdAt,
    MessageContent? content,
    MessageStatus? status,
    String? groupId,
    MessageEntity? repliedMessage,
    bool? isPinned,
    DateTime? pinnedAt,
  }) => MessageEntity(
    id: id ?? this.id,
    clientMessageId: clientMessageId ?? this.clientMessageId,
    user: user ?? this.user,
    createdAt: createdAt ?? this.createdAt,
    content: content ?? this.content,
    status: status ?? this.status,
    groupId: groupId ?? this.groupId,
    repliedMessage: repliedMessage ?? this.repliedMessage,
    isPinned: isPinned ?? this.isPinned,
  );

  @override
  List<Object?> get props => [
    id,
    clientMessageId,
    user,
    createdAt,
    content,
    status,
    groupId,
    repliedMessage,
    isPinned,
  ];
}
