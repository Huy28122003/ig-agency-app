import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';
import 'package:ig_agency_app/presentation/views/pages/workspace_attachment/bloc/workspace_attachment_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/workspace_attachment/layout/workspace_attachment_mobile_layout.dart';
import 'package:ig_agency_app/presentation/views/pages/workspace_attachment/layout/workspace_attachment_tablet_layout.dart';

@RoutePage()
class WorkspaceAttachmentPage
    extends
        BasePage<
          WorkspaceAttachmentBloc,
          WorkspaceAttachmentEvent,
          WorkspaceAttachmentState
        > {
  const WorkspaceAttachmentPage({super.key, required this.workspaceId});

  final String workspaceId;

  @override
  WorkspaceAttachmentBloc get buildBloc =>
      super.buildBloc..workspaceId = workspaceId;

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<WorkspaceAttachmentBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return WorkspaceAttachmentMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return WorkspaceAttachmentTabletLayout();
  }
}
