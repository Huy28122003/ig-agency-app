import 'package:ig_agency_app/domain/entities/message/message_entity.dart';

class GroupDetailEntity {
  const GroupDetailEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.status,
    this.recentPinnedMessage,
    required this.pinnedMessageCount,
    required this.memberCount,
    required this.onlineMemberCount,
  });

  final String id;
  final String type;
  final String title;
  final String status;
  final MessageEntity? recentPinnedMessage;
  final int pinnedMessageCount;
  final int memberCount;
  final int onlineMemberCount;
}
