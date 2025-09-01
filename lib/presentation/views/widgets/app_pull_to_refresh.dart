import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../resources/colors.dart';

class AppPullToRefresh extends StatelessWidget {
  const AppPullToRefresh({
    super.key,
    required this.refreshController,
    required this.child,
    this.enablePullDown = true,
    this.enablePullUp = true,
    this.header,
    this.onRefresh,
    this.onLoadMore,
    this.scrollController,
  });

  final RefreshController refreshController;
  final ScrollController? scrollController;
  final bool enablePullDown;
  final bool enablePullUp;
  final Widget? header;
  final Widget child;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoadMore;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      physics: const ClampingScrollPhysics(),
      controller: refreshController,
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,

      // enablePullDown: refreshController.headerStatus == RefreshStatus.completed
      //     ? enablePullDown
      //     : false,
      // enablePullUp: refreshController.footerStatus == LoadStatus.canLoading
      //     ? enablePullUp
      //     : false,
      scrollController: scrollController,
      header:
          header ?? const WaterDropHeader(waterDropColor: AppColors.primary),
      footer: CustomFooter(
        builder: (context, mode) {
          Widget body;
          if (mode != LoadStatus.noMore) {
            body = const CupertinoActivityIndicator();
          } else {
            body = const SizedBox();
          }
          return SizedBox(height: 40.0, child: Center(child: body));
        },
      ),
      onRefresh: onRefresh,
      onLoading: onLoadMore,
      child: child,
    );
  }
}
