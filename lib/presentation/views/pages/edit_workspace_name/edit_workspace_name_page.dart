import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';
import 'package:ig_agency_app/presentation/views/pages/edit_workspace_bio/bloc/edit_workspace_bio_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/edit_workspace_bio/layout/edit_workspace_bio_mobile_layout.dart';
import 'package:ig_agency_app/presentation/views/pages/edit_workspace_bio/layout/edit_workspace_bio_tablet_layout.dart';

@RoutePage()
class EditWorkspaceNamePage
    extends
        BasePage<
          EditWorkspaceNameBloc,
          EditWorkspaceNameEvent,
          EditWorkspaceNameState
        > {
  const EditWorkspaceNamePage({
    super.key,
    required this.name,
    required this.workspaceId,
  });

  final String name;
  final String workspaceId;

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<EditWorkspaceNameBloc>().add(
      LoadDataEvent(bio: name, workspaceId: workspaceId),
    );
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return EditWorkspaceNameMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return EditWorkspaceNameTabletLayout();
  }
}
