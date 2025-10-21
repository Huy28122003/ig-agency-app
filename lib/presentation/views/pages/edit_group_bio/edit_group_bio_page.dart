import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';
import 'package:ig_agency_app/presentation/views/pages/edit_group_bio/bloc/edit_group_bio_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/edit_group_bio/layout/edit_workspace_bio_mobile_layout.dart';
import 'package:ig_agency_app/presentation/views/pages/edit_group_bio/layout/edit_workspace_bio_tablet_layout.dart';

@RoutePage()
class EditGroupBioPage
    extends
        BasePage<
          EditGroupBioBloc,
          EditGroupBioEvent,
          EditGroupBioState
        > {
  const EditGroupBioPage({
    super.key,
    required this.bio,
    required this.workspaceId,
  });

  final String bio;
  final String workspaceId;

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<EditGroupBioBloc>().add(
      LoadDataEvent(bio: bio, workspaceId: workspaceId),
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

  @override
  Widget? desktopBuilder(BuildContext context) {
    return EditWorkspaceNameTabletLayout();
  }
}
