import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';
import 'package:ig_agency_app/presentation/views/pages/edit_workspace_bio/bloc/edit_workspace_bio_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/edit_workspace_bio/layout/edit_workspace_bio_mobile_layout.dart';
import 'package:ig_agency_app/presentation/views/pages/edit_workspace_bio/layout/edit_workspace_bio_tablet_layout.dart';

@RoutePage()
class EditWorkspaceBioPage
    extends
        BasePage<
          EditWorkspaceBioBloc,
          EditWorkspaceBioEvent,
          EditWorkspaceBioState
        > {
  const EditWorkspaceBioPage({
    super.key,
    required this.bio,
    required this.workspaceId,
  });

  final String bio;
  final int workspaceId;

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<EditWorkspaceBioBloc>().add(
      LoadDataEvent(bio: bio, workspaceId: workspaceId),
    );
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return EditWorkspaceBioMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return EditWorkspaceBioTabletLayout();
  }
}
