import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/edit_bio_tablet_layout.dart';
import 'layout/edit_bio_mobile_layout.dart';
import 'edit_bio_bloc.dart';

@RoutePage()
class EditBioPage extends BasePage<EditBioBloc, EditBioEvent, EditBioState> {
  const EditBioPage(this.bio, {super.key});

  final String bio;

  @override
  EditBioBloc get buildBloc => super.buildBloc..bio = bio;

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<EditBioBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return EditBioMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return EditBioTabletLayout();
  }

  @override
  Widget? desktopBuilder(BuildContext context) {
    return EditBioTabletLayout();
  }
}
