import 'package:equatable/equatable.dart';
import 'package:ig_agency_app/domain/entities/user.dart';

import '../../enums/message_enums.dart';
import 'message_content.dart';

class MessageEntity extends Equatable {
  const MessageEntity({
    required this.id,
    required this.user,
    required this.createdAt,
    required this.content,
    required this.status,
    this.groupId,
    this.repliedMessage,
    this.isPinned = false,
    this.pinnedAt,
  });

  final String id;
  final UserSummary user;
  final DateTime createdAt;
  final MessageContent content;
  final MessageStatus status;
  final String? groupId;
  final MessageEntity? repliedMessage;
  final bool isPinned;
  final DateTime? pinnedAt;

  bool get hasNotReply => repliedMessage == null;

  MessageEntity copyWith({
    String? id,
    UserSummary? user,
    DateTime? createdAt,
    MessageContent? content,
    MessageStatus? status,
    String? groupId,
    MessageEntity? repliedMessage,
    bool? isPinned,
    DateTime? pinnedAt,
  }) => MessageEntity(
    id: id ?? this.id,
    user: user ?? this.user,
    createdAt: createdAt ?? this.createdAt,
    content: content ?? this.content,
    status: status ?? this.status,
    groupId: groupId ?? this.groupId,
    repliedMessage: repliedMessage ?? this.repliedMessage,
    isPinned: isPinned ?? this.isPinned,
    pinnedAt: pinnedAt ?? this.pinnedAt,
  );

  @override
  List<Object?> get props => [
    id,
    user,
    createdAt,
    content,
    status,
    groupId,
    repliedMessage,
    isPinned,
    pinnedAt,
  ];
}
