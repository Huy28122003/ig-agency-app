import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ig_agency_app/domain/translators/received_notification_translator.dart';
import 'package:ig_agency_app/shared/extensions/string.dart';
import 'package:ig_agency_app/shared/utils/logger.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/notification/received_notification_entity.dart';
import '../../shared/commons/constants/string.dart';
import 'notification_service.dart';
import 'package:ig_agency_app/dependencies/notification/notification_web_services_stub.dart'
    if (dart.library.js_interop) 'package:ig_agency_app/dependencies/notification/notification_web_services_web.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {}

@LazySingleton(as: NotificationService)
class FirebaseNotificationService extends NotificationService {
  FirebaseNotificationService() {
    _firebaseMessaging = FirebaseMessaging.instance;
  }

  late FirebaseMessaging _firebaseMessaging;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final StreamController<ReceivedNotificationEntity>
  didReceiveLocalNotificationStream =
      StreamController<ReceivedNotificationEntity>.broadcast();

  final StreamController<ReceivedNotificationEntity> selectNotificationStream =
      StreamController<ReceivedNotificationEntity>.broadcast();

  final MethodChannel platform = const MethodChannel(
    'wsw/flutter_local_notifications',
  );

  /// Defines a iOS/MacOS notification category for text input actions.
  final String darwinNotificationCategoryText = 'textCategory';

  @override
  Stream<String> get onTokenRefresh => _firebaseMessaging.onTokenRefresh;

  @override
  Future<String?> getDeviceToken() async {
    String? vapidKey;
    if (kIsWeb) vapidKey = kVapidKey;
    await NotificationWebServices.requestPermission();
    return await _firebaseMessaging.getToken(vapidKey: vapidKey);
  }

  @override
  Future init() async {
    if (!kIsWeb) {
      await _firebaseMessaging.requestPermission();
      return await _initializeMobileApplication();
    }
    await _initializeWebApplication();
  }

  Future _initializeWebApplication() async {
    try {
      FirebaseMessaging.onMessage.listen((message) {
        print('sjhdgfhjdg    $message');
        onMessageStream.sink.add(
          message.data.toEntity(
            title: message.notification?.title,
            body: message.notification?.body,
          ),
        );
      });
    } catch (e) {
      return;
    }
  }

  Future _initializeMobileApplication() async {
    try {
      AndroidInitializationSettings? initializationSettingsAndroid;
      DarwinInitializationSettings? initializationSettingsIOS;
      if (Platform.isIOS) {
        final List<DarwinNotificationCategory> darwinNotificationCategories =
            <DarwinNotificationCategory>[
              DarwinNotificationCategory(
                darwinNotificationCategoryText,
                actions: <DarwinNotificationAction>[
                  DarwinNotificationAction.text(
                    'text_1',
                    'Action 1',
                    buttonTitle: 'Send',
                    placeholder: 'Placeholder',
                  ),
                ],
              ),
            ];
        initializationSettingsIOS = DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          notificationCategories: darwinNotificationCategories,
        );
      }
      if (Platform.isAndroid) {
        initializationSettingsAndroid = AndroidInitializationSettings(
          '@mipmap/launcher_icon',
        );
      }

      final InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
          );
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
              ReceivedNotificationEntity? data;
              if (notificationResponse.payload.isNotNullOrEmpty()) {
                data = ReceivedNotificationEntity.fromJson(
                  jsonDecode(notificationResponse.payload!),
                );
              }
              if (notificationResponse.notificationResponseType ==
                  NotificationResponseType.selectedNotification) {
                if (data != null) {
                  selectNotificationStream.add(data);
                }
              }
            },
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );
      FirebaseMessaging.onMessage.listen((message) {
        print("Receive message: $message");
        onMessageStream.sink.add(
          message.data.toEntity(
            title: message.notification?.title,
            body: message.notification?.body,
          ),
        );
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        onMessageOpenedAppStream.sink.add(
          message.data.toEntity(
            title: message.notification?.title,
            body: message.notification?.body,
          ),
        );
      });
    } catch (e) {
      return;
    }
  }

  @override
  Future<bool?> requestPermission() async {
    try {
      if (kIsWeb) {
        return await NotificationWebServices.requestPermission();
      }
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
      } else {
        final flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        return flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
      }
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future showNotification({
    String? title,
    String body = '',
    String? payload,
  }) async {
    final Random random = Random();
    final int randomId = random.nextInt(2 ^ 63 - 1);
    FlutterLocalNotificationsPlugin();
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'Thông báo đẩy',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    await flutterLocalNotificationsPlugin.show(
      randomId,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  @override
  void handleNotificationBackground(
    Future Function(RemoteMessage message) backgroundHandler,
  ) {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  }

  @override
  Stream<ReceivedNotificationEntity> getSelectNotificationStream() {
    return selectNotificationStream.stream;
  }

  @override
  Future<ReceivedNotificationEntity?> getInitNotification() async {
    // final message = await _firebaseMessaging.getInitialMessage();
    // return message?.data.toEntity()
    return null;
  }
}
