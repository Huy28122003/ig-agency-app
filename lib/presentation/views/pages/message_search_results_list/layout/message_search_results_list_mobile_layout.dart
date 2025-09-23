import 'package:auto_route/auto_route.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/message_search_results_list/bloc/message_search_results_list_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/message_search_results_list/widgets/message_result_tile.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_list_view.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';

class MessageSearchResultsListMobileLayout extends StatefulWidget {
  const MessageSearchResultsListMobileLayout({super.key});

  @override
  State<MessageSearchResultsListMobileLayout> createState() =>
      _MessageSearchResultsListMobileLayoutState();
}

class _MessageSearchResultsListMobileLayoutState
    extends State<MessageSearchResultsListMobileLayout> {
  late final MessageSearchResultsListBloc _messageSearchResultsListBloc;
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    _messageSearchResultsListBloc = context
        .read<MessageSearchResultsListBloc>();
    return Scaffold(
      backgroundColor: AppColors.surfaceBackgroundBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBackgroundBackground,
        leadingWidth: 52,
        leading: Container(
          padding: const EdgeInsets.only(left: 12),
          alignment: Alignment.centerLeft,
          child: IconButton(
            padding: const EdgeInsets.all(8),
            onPressed: () {
              context.router.pop();
            },
            icon: Assets.icons.icArrowLeft.svg(
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                AppColors.iconDefaultDefaultSub2,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          _messageSearchResultsListBloc.workspaceName,
          style: TextStyle(
            fontFamily: FontFamily.segoeUI,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            height: 28 / 22,
            color: AppColors.textDefaultTextDefault,
          ),
        ),
      ),
      body:
          BlocBuilder<
            MessageSearchResultsListBloc,
            MessageSearchResultsListState
          >(
            buildWhen: (prev, curr) =>
                prev.pagingStatus != curr.pagingStatus ||
                prev.messages != curr.messages,
            builder: (context, state) {
              return AppListView(
                refreshController: _refreshController,
                padding: EdgeInsets.zero,
                enablePullDown: false,
                onLoadMore: () {
                  _messageSearchResultsListBloc.add(GetDataEvent());
                },
                fetchStatus: state.pagingStatus,
                data: state.messages,
                builder: (_, index) {
                  return MessageResultTile(
                    message: state.messages[index],
                    messageSearch: _messageSearchResultsListBloc.searchMessage,
                  );
                },
                separatorBuilder: (_, index) {
                  return SizedBox();
                },
                numCardLoading: 6,
                cardLoading: _buildLoading(),
              );
            },
          ),
    );
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardLoading(
                height: 48,
                borderRadius: BorderRadius.all(Radius.circular(1000)),
                width: 48,
                margin: EdgeInsets.only(bottom: 10),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CardLoading(
                                height: 25,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 10),
                              ),
                              const SizedBox(height: 6),
                              CardLoading(
                                height: 20,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                width: 150,
                                margin: EdgeInsets.only(bottom: 10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
