import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import '../../../../shared/commons/enums/camera_mode.dart';
import 'layout/media_preview_mobile_layout.dart';
import 'layout/media_preview_tablet_layout.dart';
import 'media_preview_bloc.dart';

@RoutePage()
class MediaPreviewPage
    extends BasePage<MediaPreviewBloc, MediaPreviewEvent, MediaPreviewState> {
  const MediaPreviewPage({
    super.key,
    required this.avatar,
    required this.mediaPath,
    this.isPhoto = false,
    this.aspectRatio = 1,
    this.cameraMode = CameraMode.sendMessage,
  });

  final String avatar;
  final String mediaPath;
  final bool isPhoto;
  final double aspectRatio;
  final CameraMode cameraMode;

  @override
  MediaPreviewBloc get buildBloc => super.buildBloc
    ..avatar = avatar
    ..path = mediaPath
    ..isPhoto = isPhoto
    ..aspectRatio = aspectRatio
    ..cameraMode = cameraMode;

  @override
  void onInitState(BuildContext context) {
    context.read<MediaPreviewBloc>().add(LoadDataEvent());
    super.onInitState(context);
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return MediaPreviewMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return MediaPreviewTabletLayout();
  }
}
