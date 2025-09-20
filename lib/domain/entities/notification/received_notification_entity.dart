import 'package:json_annotation/json_annotation.dart';

import 'notification_entity.dart';

part 'received_notification_entity.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ReceivedNotificationEntity extends NotificationEntity {
  ReceivedNotificationEntity({
    this.notificationContent,
    required super.type,
    super.title,
    super.isRead = false,
    required super.id,
  });

  factory ReceivedNotificationEntity.fromJson(Map<String, dynamic> json) =>
      _$ReceivedNotificationEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ReceivedNotificationEntityToJson(this);

  final String? notificationContent;

  ReceivedNotificationEntity copyWith({
    String? notificationType,
    String? notificationContent,
    String? title,
    bool? isRead,
  }) {
    return ReceivedNotificationEntity(
      notificationContent: notificationContent ?? this.notificationContent,
      type: super.type,
      title: title ?? super.title,
      id: super.id,
      isRead: super.isRead,
    );
  }
}
