import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

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
  });

  final String avatar;
  final String mediaPath;
  final bool isPhoto;

  @override
  MediaPreviewBloc get buildController => super.buildController
    ..avatar = avatar
    ..path = mediaPath
    ..isPhoto = isPhoto;

  @override
  void onInitState(BuildContext context) {
    context.read<MediaPreviewBloc>().add(LoadDataEvent(avatar, mediaPath));
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
