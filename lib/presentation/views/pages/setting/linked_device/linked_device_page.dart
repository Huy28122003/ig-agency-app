import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/linked_device_tablet_layout.dart';
import 'layout/linked_device_mobile_layout.dart';
import 'linked_device_bloc.dart';

@RoutePage()
class LinkedDevicePage
    extends BasePage<LinkedDeviceBloc, LinkedDeviceEvent, LinkedDeviceState> {
  const LinkedDevicePage({super.key});

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<LinkedDeviceBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return LinkedDeviceMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return LinkedDeviceTabletLayout();
  }
}
