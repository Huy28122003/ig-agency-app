import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import '../../../../../di/di.dart';
import '../../../../../domain/usecases/get_pinned_message_summary_workspace_use_case.dart';
import '../../../../../domain/usecases/message/fetch_messages_workspace_use_case.dart';
import 'layout/workspace_detail_tablet_layout.dart';
import 'layout/workspace_detail_mobile_layout.dart';
import 'workspace_detail_bloc.dart';

@RoutePage()
class WSDetailPage
    extends BasePage<WSDetailBloc, WSDetailEvent, WSDetailState> {
  const WSDetailPage({
    super.key,
    required this.workspaceId,
    required this.userId,
  });

  final int workspaceId;
  final String userId;

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<WSDetailBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return WorkspaceDetailMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return WorkspaceDetailTabletLayout();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<WSDetailBloc>(
      create: (_) => WSDetailBloc(
        workspaceId: workspaceId,
        userId: userId,
        fetchMessageUseCase: getIt<FetchMessagesWorkspaceUseCase>(),
        getPinnedMessageSummaryWorkspaceUseCase:
            getIt<GetPinnedMessageSummaryWorkspaceUseCase>(),
      ),
      child: this,
    );
  }
}
