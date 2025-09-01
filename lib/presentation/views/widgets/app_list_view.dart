import 'package:flutter/material.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:ig_agency_app/shared/extensions/widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import 'app_pull_to_refresh.dart';

class AppListView<T> extends StatefulWidget {
  const AppListView({
    super.key,
    required this.data,
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 40),
    this.refreshController,
    this.onRefresh,
    this.onLoadMore,
    this.emptyMessage,
    this.errorMessage,
    this.errorPress,
    required this.builder,
    this.separatorBuilder,
    this.enablePullDown = true,
    this.enablePullUp = true,
    this.paddingLoadingView = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 24,
    ),
    this.fetchStatus = PagingStatus.idle,
    this.controller,
    this.cardLoading,
    this.numCardLoading = 5,
  });

  final List<T> data;
  final EdgeInsets padding;
  final RefreshController? refreshController;
  final ScrollController? controller;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoadMore;
  final String? emptyMessage;
  final String? errorMessage;
  final Function()? errorPress;
  final Widget Function(T data, int index) builder;
  final IndexedWidgetBuilder? separatorBuilder;
  final bool enablePullDown;
  final bool enablePullUp;
  final EdgeInsets paddingLoadingView;
  final PagingStatus fetchStatus;
  final Widget? cardLoading;
  final int numCardLoading;

  @override
  State<AppListView<T>> createState() => _AppListViewState<T>();
}

class _AppListViewState<T> extends State<AppListView<T>> {
  late RefreshController _refreshController;
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = widget.controller ?? ScrollController();
    _refreshController = widget.refreshController ?? RefreshController();
    _refreshController.refresh(widget.fetchStatus);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AppListView<T> oldWidget) {
    if (oldWidget.fetchStatus != widget.fetchStatus) {
      _refreshController.refresh(widget.fetchStatus);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AppPullToRefresh(
      refreshController: _refreshController,
      onRefresh: widget.onRefresh,
      onLoadMore: widget.onLoadMore,
      enablePullUp: widget.enablePullUp,
      enablePullDown: widget.enablePullDown,
      scrollController: _scrollController,
      child: widget.data.safeWithPageState(
        (it) {
          return ListView.separated(
            controller: _scrollController,
            itemCount: it.length,
            padding: widget.padding,
            separatorBuilder:
                widget.separatorBuilder ??
                (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return widget.builder(widget.data[index], index);
            },
          );
        },
        separatorBuilder: widget.separatorBuilder,
        widget.fetchStatus,
        padding: widget.padding,
        emptyMessage: widget.emptyMessage,
        errorMessage: widget.errorMessage,
        errorPress: widget.errorPress,
        numberCardLoading: widget.numCardLoading,
        cardLoading: widget.cardLoading,
      ),
    );
  }
}
