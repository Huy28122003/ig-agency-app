import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';
import 'package:ig_agency_app/presentation/views/pages/camera/widgets/camera_view.dart';
import 'package:ig_agency_app/presentation/views/pages/camera/widgets/take_media_button.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_button.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import '../../../../../gen/assets.gen.dart';
import '../camera_bloc.dart';

class CameraMobileLayout extends StatefulWidget {
  const CameraMobileLayout({super.key});

  @override
  State<CameraMobileLayout> createState() => _CameraMobileLayoutState();
}

class _CameraMobileLayoutState extends State<CameraMobileLayout>
    with WidgetsBindingObserver {
  late final CameraBloc _cameraBloc;

  @override
  void initState() {
    super.initState();
    _cameraBloc = context.read<CameraBloc>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    context.read<CameraBloc>().add(AppLifecycleChangedEvent(state));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CameraBloc, CameraState>(
          listenWhen: (pre, cur) => pre.media != cur.media,
          listener: (context, state) async {
            if (state.media.isNotEmpty) {
              _cameraBloc.add(
                AppLifecycleChangedEvent(AppLifecycleState.inactive),
              );
              final aspectRatio = _cameraBloc.controller?.value.aspectRatio;
              final path = await context.router.push(
                MediaPreviewRoute(
                  avatar:
                      "https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png",
                  mediaPath: state.media,
                  isPhoto: state.isPhoto,
                  aspectRatio: 1 / (aspectRatio ?? 1),
                  cameraMode: _cameraBloc.cameraMode,
                ),
              );
              if (path is String && context.mounted) {
                context.router.pop(path);
              } else {
                _cameraBloc.add(
                  AppLifecycleChangedEvent(AppLifecycleState.resumed),
                );
              }
            }
          },
        ),
        BlocListener<CameraBloc, CameraState>(
          listenWhen: (pre, cur) => pre.status != cur.status,
          listener: (context, state) {
            if (state.status.isNotAvailable) {
              // context.router.pop();
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainerGrayStrong95,
        body: SafeArea(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CameraView(),
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
                        AppButton.icon(
                          onPressed: () {
                            _cameraBloc.add(ReverseCameraEvent());
                          },
                          icon: Assets.icons.icCameraReverse.svg(
                            width: 24,
                            height: 24,
                          ),
                        ),
                        BlocSelector<CameraBloc, CameraState, (bool, bool)>(
                          selector: (state) =>
                              (state.isFlashEnabled, state.inProgress),
                          builder: (context, data) {
                            return AnimatedSize(
                              duration: Duration(milliseconds: 350),
                              child: data.$2
                                  ? SizedBox()
                                  : AppButton.icon(
                                      onPressed: () {
                                        _cameraBloc.add(ChangeFlashEvent());
                                      },
                                      icon: data.$1
                                          ? Assets.icons.icFlashEnable.svg()
                                          : Assets.icons.icFlashDisable.svg(),
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                      bottom: 20,
                      right: 20,
                    ),
                    // height: 80,
                    child: BlocSelector<CameraBloc, CameraState, bool>(
                      selector: (state) => state.inProgress,
                      builder: (BuildContext context, bool inProgress) {
                        return Row(
                          children: [
                            Expanded(
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 350),
                                opacity: inProgress ? 0 : 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: AppButton.icon(
                                    onPressed: () {
                                      _cameraBloc.add(PickMediaEvent());
                                    },
                                    icon: Assets.icons.icAlbum.svg(
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TakeMediaButton(
                                onTap: () {
                                  _cameraBloc.add(TakePhotoEvent());
                                },
                                onLongPressStart: () {
                                  _cameraBloc.add(StartRecordEvent());
                                },
                                onLongPressEnd: () {
                                  _cameraBloc.add(StopRecordEvent());
                                },
                                isInProgress: inProgress,
                              ),
                            ),
                            Spacer(),
                          ],
                        );
                      },
                    ),
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
