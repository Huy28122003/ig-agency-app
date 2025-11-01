import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import '../../../../shared/commons/enums/media_use_case.dart';
import 'layout/camera_mobile_layout.dart';
import 'layout/camera_tablet_layout.dart';
import 'camera_bloc.dart';

@RoutePage()
class CameraPage extends BasePage<CameraBloc, CameraEvent, CameraState> {
  const CameraPage({
    super.key,
    this.mediaUseCase = MediaUseCase.sendMessage,
    this.avatarGroup,
  });

  final MediaUseCase mediaUseCase;
  final String? avatarGroup;

  @override
  CameraBloc get buildBloc => super.buildBloc
    ..avatar = avatarGroup
    ..cameraMode = mediaUseCase;

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<CameraBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return CameraMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return SettingHomeTabletLayout();
  }
}
