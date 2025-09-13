import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'create_group_bloc.dart';
import 'layout/create_group_mobile_layout.dart';
import 'layout/create_group_tablet_layout.dart';

@RoutePage()
class CreateGroupPage
    extends BasePage<CreateGroupBloc, CreateGroupEvent, CreateGroupState> {
  const CreateGroupPage({super.key});

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<CreateGroupBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return CreateGroupMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return CreateGroupTabletLayout();
  }
}
