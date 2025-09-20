import 'package:json_annotation/json_annotation.dart';

part 'notification_entity.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class NotificationEntity {
  NotificationEntity({
    required this.id,
    this.title = '',
    required this.isRead,
    required this.type,
  });

  factory NotificationEntity.fromJson(Map<String, dynamic> json) =>
      _$NotificationEntityFromJson(json);

  final String id;
  final String title;
  final bool isRead;
  final String type;

  Map<String, dynamic> toJson() => _$NotificationEntityToJson(this);
}
