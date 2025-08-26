import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/workspace_detail_tablet_layout.dart';
import 'layout/workspace_detail_mobile_layout.dart';
import 'workspace_detail_bloc.dart';

@RoutePage()
class WSDetailPage
    extends BasePage<WSDetailBloc, WSDetailEvent, WSDetailState> {
  const WSDetailPage({super.key});

  @override
  void onInitState(BuildContext context) {
    context.read<WSDetailBloc>().add(LoadDataEvent());
    super.onInitState(context);
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return WorkspaceDetailMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return WorkspaceDetailTabletLayout();
  }
}
