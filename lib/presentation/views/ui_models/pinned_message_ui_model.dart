import 'package:equatable/equatable.dart';

import '../../../domain/entities/message/message.dart';

class PinnedMessageUIModel extends Equatable {
  const PinnedMessageUIModel({
    this.id,
    required this.userName,
    required this.userAvatar,
    required this.pinnedAt,
    required this.content,
  });

  final String? id;
  final String userName;
  final String userAvatar;
  final DateTime pinnedAt;
  final MessageContent content;

  @override
  List<Object?> get props => [id, userName, userAvatar, pinnedAt, content];
}

extension PinnedMessageUIModelMapper on MessageEntity {
  PinnedMessageUIModel toUIModel() {
    return PinnedMessageUIModel(
      id: id,
      userName: user.name,
      userAvatar: user.avatar,
      pinnedAt: pinnedAt ?? DateTime.now(),
      content: content,
    );
  }
}
