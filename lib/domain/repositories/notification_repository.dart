import 'package:firebase_messaging/firebase_messaging.dart';

import '../entities/notification/received_notification_entity.dart';

abstract class NotificationRepository {
  Future<bool> requestPermission();

  Future initNotification();

  Future<String?> getDeviceToken();

  Stream<String> get onTokenRefresh;

  Future showNotification({
    String title = '',
    String body = '',
    String? payload,
  });

  Stream<ReceivedNotificationEntity> get onMessageOpenedApp;

  Stream<ReceivedNotificationEntity> get onMessage;

  void handleNotificationBackground(
    Future Function(RemoteMessage message) backgroundHandler,
  );
}
