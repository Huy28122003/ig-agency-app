import '../entities/notification/received_notification_entity.dart';

extension ReceivedNotificationEntityTranslator on Map<String, dynamic> {
  ReceivedNotificationEntity toEntity({String? title, String? body}) {
    return ReceivedNotificationEntity(
      id: DateTime.now().toString(),
      type: 'notificationType',
      title: 'title',
      notificationContent: body,
    );
  }
}
