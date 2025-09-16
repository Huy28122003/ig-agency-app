import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/linked_device/linked_device_entity.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/device_detail_tablet_layout.dart';
import 'layout/device_detail_mobile_layout.dart';
import 'device_detail_bloc.dart';

@RoutePage()
class DeviceDetailPage
    extends BasePage<DeviceDetailBloc, DeviceDetailEvent, DeviceDetailState> {
  final LinkedDeviceEntity device;

  const DeviceDetailPage({super.key, required this.device});

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<DeviceDetailBloc>().add(InitDataEvent(device: device));
    context.read<DeviceDetailBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return DeviceDetailMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return DeviceDetailTabletLayout();
  }
}
