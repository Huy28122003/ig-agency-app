import 'dart:async';

import 'package:ig_agency_app/domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

import '../domain/entities/notification/received_notification_entity.dart';
import '../presentation/base/base_bloc.dart';
import '../presentation/base/base_state.dart';
import '../shared/commons/enums/status.dart';

part 'app_event.dart';

part 'app_state.dart';

@injectable
class AppBloc extends BaseBloc<AppEvent, AppState> {
  AppBloc(this._notificationRepository) : super(AppState()) {
    _registerHandlers();
    _onMessageStream = _notificationRepository.onMessage.listen((notification) {
      _onForegroundMessage(notification);
    });
  }

  final NotificationRepository _notificationRepository;
  StreamSubscription? _onMessageStream;

  void _registerHandlers() {}

  Future _onForegroundMessage(ReceivedNotificationEntity notification) async {
    try {
      _notificationRepository.showNotification(
        title: notification.title,
        body: notification.notificationContent ?? '',
      );
    } catch (e) {
      return;
    }
  }

  @override
  Future<void> close() {
    _onMessageStream?.cancel();
    return super.close();
  }
}
