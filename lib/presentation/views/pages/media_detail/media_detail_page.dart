import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';
import 'package:ig_agency_app/presentation/views/pages/media_detail/bloc/media_detail_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/media_detail/layout/media_detail_mobile_layout.dart';
import 'package:ig_agency_app/presentation/views/pages/media_detail/layout/media_detail_tablet_layout.dart';

@RoutePage()
class MediaDetailPage
    extends BasePage<MediaDetailBloc, MediaDetailEvent, MediaDetailState> {
  const MediaDetailPage({super.key, required this.url, required this.isVideo});

  final String url;
  final bool isVideo;

  @override
  MediaDetailBloc get buildBloc => super.buildBloc
    ..url = url
    ..isVideo = isVideo;

  @override
  void onInitState(BuildContext context) {
    context.read<MediaDetailBloc>().add(LoadDataEvent());
    super.onInitState(context);
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return MediaDetailMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return MediaDetailTabletLayout();
  }
}
