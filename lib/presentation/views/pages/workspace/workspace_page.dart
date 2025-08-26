import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';
import 'package:ig_agency_app/presentation/views/pages/workspace/bloc/workspace_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/workspace/layout/workspace_mobile_layout.dart';

@RoutePage()
class WorkspacePage
    extends BasePage<WorkspaceBloc, WorkspaceEvent, WorkspaceState> {
  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<WorkspaceBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return WorkspaceMobileLayout();
  }
}
