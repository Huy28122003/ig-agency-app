import 'package:equatable/equatable.dart';

import '../../../domain/entities/message/message.dart';

class PinnedMessageUIModel extends Equatable {
  const PinnedMessageUIModel({
    this.id,
    required this.userName,
    required this.userAvatar,
    required this.createdAt,
    required this.content,
  });

  final String? id;
  final String userName;
  final String userAvatar;
  final DateTime createdAt;
  final MessageContent content;

  @override
  List<Object?> get props => [id, userName, userAvatar, createdAt, content];
}

extension PinnedMessageUIModelMapper on MessageEntity {
  PinnedMessageUIModel toUIModel() {
    return PinnedMessageUIModel(
      id: id,
      userName: user.name,
      userAvatar: user.avatar,
      createdAt: createdAt,
      content: content,
    );
  }
}
