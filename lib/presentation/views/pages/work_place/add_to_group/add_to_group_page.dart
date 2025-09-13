import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'add_to_group_bloc.dart';
import 'layout/add_to_group_mobile_layout.dart';
import 'layout/add_to_group_tablet_layout.dart';

@RoutePage()
class AddToGroupPage
    extends BasePage<AddToGroupBloc, AddToGroupEvent, AddToGroupState> {
  const AddToGroupPage({super.key});

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<AddToGroupBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return AddToGroupMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return AddToGroupTabletLayout();
  }
}
