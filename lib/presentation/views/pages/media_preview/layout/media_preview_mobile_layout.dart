import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_button.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/commons/enums/media_use_case.dart';
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
    final aspectRatio = _bloc.aspectRatio;
    return MultiBlocListener(
      listeners: [
        BlocListener<MediaPreviewBloc, MediaPreviewState>(
          listenWhen: (pre, cur) => pre.isCropSuccess != cur.isCropSuccess,
          listener: (context, state) {
            if (state.isCropSuccess) {
              context.router.pop(state.path);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainerGrayStrong95,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
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
                            BlocSelector<
                              MediaPreviewBloc,
                              MediaPreviewState,
                              String
                            >(
                              selector: (state) => state.path,
                              builder: (context, path) {
                                return (path.isEmpty)
                                    ? Center(child: CircularProgressIndicator())
                                    : (aspectRatio == null)
                                    ? SizedBox(
                                        height: constraints.maxHeight * 0.9,
                                        width: constraints.maxWidth,
                                        child: _buildCenter(
                                          _bloc.isPhoto,
                                          path,
                                          constraints.maxWidth / 2,
                                        ),
                                      )
                                    : AspectRatio(
                                        aspectRatio: aspectRatio,
                                        child: _buildCenter(
                                          _bloc.isPhoto,
                                          path,
                                          constraints.maxWidth / 2,
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
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 8,
                          right: 10,
                        ),
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
                                icon: Assets.icons.icCrop.svg(
                                  width: 24,
                                  height: 24,
                                ),
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
                      child: _bloc.mediaUseCase.isCaptureOnly
                          ? SetAvatarButton(
                              onTap: () {
                                _bloc.add(ConfirmEvent());
                              },
                            )
                          : SendButtonWidget(
                              avatar: _bloc.avatar ?? '',
                              onTap: () {
                                _bloc.add(ConfirmEvent());
                              },
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCenter(bool isPhoto, String path, [double radius = 0]) {
    return isPhoto
        ? Stack(
            alignment: Alignment.center,
            children: [
              FittedBox(child: Image.file(File(path))),
              if (_bloc.mediaUseCase == MediaUseCase.updateAvatar)
                Positioned.fill(child: CircularCropMask(radius: radius)),
            ],
          )
        : AppVideoPlayer(path: path, isAutoPlay: true);
  }
}
