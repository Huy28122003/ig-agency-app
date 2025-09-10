import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_button.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../widgets/app_video_player.dart';
import '../media_preview_bloc.dart';
import '../widgets/send_button_widget.dart';

class MediaPreviewMobileLayout extends StatefulWidget {
  const MediaPreviewMobileLayout({super.key});

  @override
  State<MediaPreviewMobileLayout> createState() =>
      _MediaPreviewMobileLayoutState();
}

class _MediaPreviewMobileLayoutState extends State<MediaPreviewMobileLayout> {
  late final MediaPreviewBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<MediaPreviewBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerGrayStrong95,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  child:
                      BlocSelector<MediaPreviewBloc, MediaPreviewState, String>(
                        selector: (state) => state.path,
                        builder: (context, path) {
                          return (path.isEmpty)
                              ? Center(child: CircularProgressIndicator())
                              : _bloc.isPhoto
                              ? Image.file(File(path))
                              : AppVideoPlayer(path: path, isAutoPlay: true);
                        },
                      ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 8, right: 10),
                  child: Row(
                    children: [
                      AppButton.icon(
                        onPressed: () {
                          context.router.pop();
                        },
                        icon: Assets.icons.icCloseSize24.svg(
                          width: 24,
                          height: 24,
                        ),
                      ),
                      Spacer(),
                      if (_bloc.isPhoto)
                        AppButton.icon(
                          onPressed: () {
                            _bloc.add(EditMediaEvent());
                          },
                          icon: Assets.icons.icCrop.svg(width: 24, height: 24),
                        ),
                      AppButton.icon(
                        onPressed: () {
                          _bloc.add(SaveMediaEvent());
                        },
                        icon: Assets.icons.icDownload.svg(
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: SafeArea(
                child: SendButtonWidget(avatar: _bloc.avatar, onTap: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
