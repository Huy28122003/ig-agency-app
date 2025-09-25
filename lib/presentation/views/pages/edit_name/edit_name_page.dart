import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/edit_name_tablet_layout.dart';
import 'layout/edit_name_mobile_layout.dart';
import 'edit_name_bloc.dart';

@RoutePage()
class EditNamePage
    extends BasePage<EditNameBloc, EditNameEvent, EditNameState> {
  const EditNamePage(this.name, {super.key});
  final String name;

  @override
  EditNameBloc get buildBloc => super.buildBloc..name = name;

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<EditNameBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return EditNameMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return EditNameTabletLayout();
  }
}
