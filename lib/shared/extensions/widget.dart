import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

extension RefreshControllerExtension on RefreshController {
  void refresh(PagingStatus fetchStatus) {
    switch (fetchStatus) {
      case PagingStatus.loading:
        requestLoading();
        break;
      case PagingStatus.loadCompleted:
        resetNoData();
        loadComplete();
        break;
      case PagingStatus.refreshing:
        requestRefresh();
        break;
      case PagingStatus.refreshCompleted:
        resetNoData();
        refreshCompleted();
        break;
      case PagingStatus.refreshFailed:
        return refreshFailed();
      case PagingStatus.loadFailed:
        return loadFailed();
      case PagingStatus.noMoreData:
        refreshCompleted();
        loadNoData();
        break;
      default:
        break;
    }
  }
}
