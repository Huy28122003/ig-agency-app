import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/commons/enums/media_use_case.dart';
import '../../../../resources/colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_video_player.dart';
import '../media_preview_bloc.dart';
import '../widgets/circular_crop_mask.dart';
import '../widgets/send_button_widget.dart';
import '../widgets/set_avatar_button.dart';

class MediaPreviewTabletLayout extends StatefulWidget {
  const MediaPreviewTabletLayout({super.key});

  @override
  State<MediaPreviewTabletLayout> createState() =>
      _MediaPreviewTabletLayoutState();
}

class _MediaPreviewTabletLayoutState extends State<MediaPreviewTabletLayout> {
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
    final double imageHeight = (screenWidth / (_bloc.aspectRatio ?? 1.0));
    final double circleRadius = (min(imageWidth, imageHeight) / 2);
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
                        BlocSelector<
                          MediaPreviewBloc,
                          MediaPreviewState,
                          String
                        >(
                          selector: (state) => state.path,
                          builder: (context, path) {
                            return (path.isEmpty)
                                ? Center(child: CircularProgressIndicator())
                                : _bloc.isPhoto
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: Image.file(File(path)).image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      if (_bloc.mediaUseCase ==
                                          MediaUseCase.updateAvatar)
                                        Positioned.fill(
                                          child: CircularCropMask(
                                            radius: circleRadius,
                                          ),
                                        ),
                                    ],
                                  )
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
                        if (_bloc.isPhoto &&
                            _bloc.mediaUseCase != MediaUseCase.updateAvatar)
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
                  child: _bloc.mediaUseCase == MediaUseCase.updateAvatar
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
          ),
        ),
      ),
    );
  }
}
