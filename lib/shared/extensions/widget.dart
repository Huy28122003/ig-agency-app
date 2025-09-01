import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_card_loading.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

extension RefreshControllerExtension on RefreshController {
  void refresh(PagingStatus fetchStatus) {
    switch (fetchStatus) {
      case PagingStatus.loadCompleted:
        resetNoData();
        loadComplete();
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

extension ScopeFunctionForObject<T extends Object> on T? {
  Widget safeWithPageState(
    Widget Function(T it) operationFor,
    PagingStatus pageState, {
    EdgeInsets padding = EdgeInsets.zero,
    int numberCardLoading = 3,
    String? emptyMessage,
    Function? errorPress,
    String? errorMessage,
    Widget? cardLoading,
    IndexedWidgetBuilder? separatorBuilder,
  }) {
    if (pageState == PagingStatus.loadFailed) {
      return SizedBox();
    }
    if (pageState == PagingStatus.idle || this == null) {
      return ListView.separated(
        itemBuilder: (context, index) =>
            cardLoading ?? AppCardLoading(padding: padding),
        itemCount: numberCardLoading,
        shrinkWrap: true,
        padding: padding,
        separatorBuilder:
            separatorBuilder ?? (_, _) =>  const SizedBox(height: 16),
        physics: const NeverScrollableScrollPhysics(),
      );
    }
    return operationFor(this!);
  }
}

extension ListSpaceBetweenExtension on List<Widget> {
  List<Widget> withSpaceBetween({double? width, double? height}) {
    return [
      for (int i = 0; i < length; i++) ...[
        if (i > 0) SizedBox(width: width, height: height),
        this[i],
      ],
    ];
  }

  List<Widget> withWidgetBetween(Widget widget) {
    return [
      for (int i = 0; i < length; i++) ...[if (i > 0) widget, this[i]],
    ];
  }
}
