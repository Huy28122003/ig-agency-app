import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'bloc/edit_group_name_bloc.dart';
import 'layout/edit_group_name_mobile_layout.dart';
import 'layout/edit_group_name_tablet_layout.dart';

@RoutePage()
class EditGroupNamePage
    extends
        BasePage<EditGroupNameBloc, EditGroupNameEvent, EditGroupNameState> {
  const EditGroupNamePage({
    super.key,
    required this.name,
    required this.workspaceId,
  });

  final String name;
  final String workspaceId;

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<EditGroupNameBloc>().add(
      LoadDataEvent(bio: name, workspaceId: workspaceId),
    );
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return EditGroupNameMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return EditGroupNameTabletLayout();
  }

  @override
  Widget? desktopBuilder(BuildContext context) {
    return EditGroupNameTabletLayout();
  }
}
