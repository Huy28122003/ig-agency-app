import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_button.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/commons/enums/camera_mode.dart';
import '../../../widgets/app_video_player.dart';
import '../media_preview_bloc.dart';
import '../widgets/circular_crop_mask.dart';
import '../widgets/send_button_widget.dart';
import '../widgets/set_avatar_button.dart';

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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageWidth = screenWidth;
    final double imageHeight = (screenWidth / _bloc.aspectRatio);
    final double circleRadius = (min(imageWidth, imageHeight) / 2);

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerGrayStrong95,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
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
                              : AspectRatio(
                                  aspectRatio: _bloc.aspectRatio,
                                  child: _bloc.isPhoto
                                      ? Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            FittedBox(
                                              child: Image.file(File(path)),
                                            ),
                                            if (_bloc.cameraMode ==
                                                CameraMode.updateAvatar)
                                              Positioned.fill(
                                                child: CircularCropMask(
                                                  radius: circleRadius,
                                                ),
                                              ),
                                          ],
                                        )
                                      : AppVideoPlayer(
                                          path: path,
                                          isAutoPlay: true,
                                        ),
                                );
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
                child: _bloc.cameraMode == CameraMode.updateAvatar
                    ? SetAvatarButton(
                        avatar: _bloc.avatar,
                        onTap: () {
                          _bloc.add(
                            CropAvatarEvent(
                              circleRadius: circleRadius,
                              imageWidth: imageWidth,
                              imageHeight: imageHeight,
                              onComplete: (path) {
                                context.router.pop(path);
                              },
                            ),
                          );
                        },
                      )
                    : SendButtonWidget(
                        avatar: _bloc.avatar,
                        onTap: () {
                          final path = _bloc.state.path;
                          if (path.isEmpty) return;

                          context.router.pop(path);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
