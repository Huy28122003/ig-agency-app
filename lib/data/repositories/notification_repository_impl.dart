import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ig_agency_app/data/local/app/notification_local_data_source.dart';
import 'package:ig_agency_app/data/remote/app/notification_remote_data_source.dart';
import 'package:ig_agency_app/dependencies/notification/notification_service.dart';
import 'package:ig_agency_app/domain/entities/notification/received_notification_entity.dart';
import 'package:ig_agency_app/domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: NotificationRepository)
class NotificationRepositoryImpl extends NotificationRepository {
  final NotificationService _notificationService;
  final NotificationRemoteDataSource _remoteDataSource;
  final NotificationLocalDataSource _localDataSource;

  NotificationRepositoryImpl(
    this._notificationService,
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Stream<String> get onTokenRefresh => _notificationService.onTokenRefresh;

  @override
  Future<String?> getDeviceToken() => _notificationService.getDeviceToken();

  @override
  void handleNotificationBackground(
    Future Function(RemoteMessage message) backgroundHandler,
  ) {
    return _notificationService.handleNotificationBackground(backgroundHandler);
  }

  @override
  Future initNotification() async {
    return _notificationService.init();
  }

  @override
  Stream<ReceivedNotificationEntity> get onMessage =>
      _notificationService.onMessage;

  @override
  Stream<ReceivedNotificationEntity> get onMessageOpenedApp =>
      _notificationService.onMessageOpenedApp;

  @override
  Future<bool> requestPermission() async {
    final isEnable = await _notificationService.requestPermission();
    return isEnable ?? false;
  }

  @override
  Future showNotification({
    String title = '',
    String body = '',
    String? payload,
  }) async {
    return await _notificationService.showNotification(
      title: title,
      body: body,
      payload: payload,
    );
  }
}
