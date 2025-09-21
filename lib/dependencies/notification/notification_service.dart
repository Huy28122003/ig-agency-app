import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/notification/received_notification_entity.dart';

abstract class NotificationService {
  @protected
  final StreamController<ReceivedNotificationEntity> onMessageOpenedAppStream =
      StreamController<ReceivedNotificationEntity>.broadcast();

  @protected
  final StreamController<ReceivedNotificationEntity> onMessageStream =
      StreamController<ReceivedNotificationEntity>.broadcast();

  Future<String?> getDeviceToken();

  Stream<String> deviceTokenRefresh();

  Future init();

  Future<bool?> requestPermission();

  Future showNotification({
    String title = '',
    String body = '',
    String? payload,
  });

  Stream<ReceivedNotificationEntity> get onMessageOpenedApp =>
      onMessageOpenedAppStream.stream;

  Stream<ReceivedNotificationEntity> get onMessage => onMessageStream.stream;

  void handleNotificationBackground(
    Future Function(RemoteMessage message) backgroundHandler,
  );

  Stream<ReceivedNotificationEntity> getSelectNotificationStream();

  Future<ReceivedNotificationEntity?> getInitNotification();
}
