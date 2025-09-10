import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/media_edit_mobile_layout.dart';
import 'layout/media_edit_tablet_layout.dart';
import 'media_edit_bloc.dart';

@RoutePage()
class MediaEditPage
    extends BasePage<MediaEditBloc, MediaEditEvent, MediaEditState> {
  const MediaEditPage({
    super.key,
    required this.mediaPath,
    this.isPhoto = false,
  });

  final String mediaPath;
  final bool isPhoto;

  @override
  MediaEditBloc get buildController => super.buildController
    ..path = mediaPath
    ..isPhoto = isPhoto;

  @override
  void onInitState(BuildContext context) {
    context.read<MediaEditBloc>().add(LoadDataEvent(mediaPath));
    super.onInitState(context);
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return MediaEditMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return MediaEditTabletLayout();
  }
}
