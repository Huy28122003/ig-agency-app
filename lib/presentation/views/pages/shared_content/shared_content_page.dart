import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/shared_content_tablet_layout.dart';
import 'layout/shared_content_mobile_layout.dart';
import 'shared_content_bloc.dart';

@RoutePage()
class SharedContentPage
    extends
        BasePage<SharedContentBloc, SharedContentEvent, SharedContentState> {
  const SharedContentPage({super.key});

  @override
  void onInitState(BuildContext context) {
    context.read<SharedContentBloc>().add(LoadDataEvent());
    super.onInitState(context);
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return SharedContentMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return SharedContentTabletLayout();
  }
}
