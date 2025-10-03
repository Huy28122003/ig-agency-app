import 'package:ig_agency_app/dependencies/local_storage/local_storage_manager.dart';
import 'package:injectable/injectable.dart';

import '../app/notification_local_data_source.dart';

@Injectable(as: NotificationLocalDataSource)
class NotificationLocalDataSourceImpl extends NotificationLocalDataSource {
  final LocalStorageManager _localStorageManager;

  NotificationLocalDataSourceImpl(this._localStorageManager);
}
