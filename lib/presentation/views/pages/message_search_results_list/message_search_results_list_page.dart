import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';
import 'package:ig_agency_app/presentation/views/pages/message_search_results_list/bloc/message_search_results_list_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/message_search_results_list/layout/message_search_results_list_mobile_layout.dart';
import 'package:ig_agency_app/presentation/views/pages/message_search_results_list/layout/message_search_results_list_tablet_layout.dart';

@RoutePage()
class MessageSearchResultsListPage
    extends
        BasePage<
          MessageSearchResultsListBloc,
          MessageSearchResultsListEvent,
          MessageSearchResultsListState
        > {
  const MessageSearchResultsListPage({
    super.key,
    required this.workspaceId,
    required this.searchMessage,
    required this.workspaceName,
  });

  final String searchMessage;
  final int workspaceId;
  final String workspaceName;

  @override
  MessageSearchResultsListBloc get buildBloc => super.buildBloc
    ..searchMessage = searchMessage
    ..workspaceId = workspaceId
    ..workspaceName = workspaceName;

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<MessageSearchResultsListBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return MessageSearchResultsListMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return MessageSearchResultsListTabletLayout();
  }
}
