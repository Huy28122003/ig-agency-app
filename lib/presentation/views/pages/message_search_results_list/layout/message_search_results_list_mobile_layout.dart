import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/message_search_results_list/bloc/message_search_results_list_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/message_search_results_list/widgets/message_result_tile.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_list_view.dart';

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

  @override
  void initState() {
    super.initState();

    _messageSearchResultsListBloc = context
        .read<MessageSearchResultsListBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.white,
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
              );
            },
          ),
    );
  }
}
