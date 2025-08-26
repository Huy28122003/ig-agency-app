enum ViewStatus { initial, loading, success, failure }

extension ViewStatusExtension on ViewStatus {
  bool get isInitial => this == ViewStatus.initial;

  bool get isLoading => this == ViewStatus.loading;

  bool get isSuccess => this == ViewStatus.success;

  bool get isFailure => this == ViewStatus.failure;
}

enum PageStatus { initial, loading, loaded, failure, refreshing }

extension PageStatusExtension on PageStatus {
  bool get isInitial => this == PageStatus.initial;

  bool get isLoading => this == PageStatus.loading;

  bool get isLoaded => this == PageStatus.loaded;

  bool get isFailure => this == PageStatus.failure;

  bool get isRefreshing => this == PageStatus.refreshing;

  bool get inProgress =>
      this == PageStatus.loading ||
      this == PageStatus.refreshing ||
      this == PageStatus.initial;
}

enum PagingStatus {
  idle,
  loading,
  loadCompleted,
  refreshCompleted,
  empty,
  loadFailed,
  refreshFailed,
  refreshing,
  noMoreData,
}

extension PagingStatusExtension on PagingStatus {
  bool get isInitial => this == PagingStatus.idle;

  bool get isLoading => this == PagingStatus.loading;

  bool get isLoadCompleted => this == PagingStatus.loadCompleted;

  bool get isRefreshCompleted => this == PagingStatus.refreshCompleted;

  bool get isEmpty => this == PagingStatus.empty;

  bool get isLoadFailure => this == PagingStatus.loadFailed;

  bool get isRefreshFailed => this == PagingStatus.refreshFailed;

  bool get isRefreshing => this == PagingStatus.refreshing;

  bool get isNoMoreData => this == PagingStatus.noMoreData;
}

enum VerifyStatus { initial, valid, invalid }
