import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
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
    context.read<CameraBloc>().add(AppLifecycleChangedEvent(state));
    super.didChangeAppLifecycleState(state);
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
          listener: (context, state) {
            if (state.isCompleted) {
              // context.router.push(WSDetailRoute());
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
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BlocSelector<CameraBloc, CameraState, CameraStatus>(
                    selector: (state) => state.status,
                    builder: (context, status) {
                      final cameraController = _cameraBloc.controller;
                      if (!status.isReady || cameraController == null) {
                        return Container(
                          child: Assets.images.splashBackground.image(
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      return CameraPreview(cameraController);
                    },
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
                        AppButton.icon(
                          onPressed: () {
                            _cameraBloc.add(ReverseCameraEvent());
                          },
                          icon: Assets.icons.icCameraReverse.svg(
                            width: 24,
                            height: 24,
                          ),
                        ),
                        BlocSelector<CameraBloc, CameraState, bool>(
                          selector: (state) => state.isFlashEnabled,
                          builder: (context, isFlashEnabled) {
                            return AppButton.icon(
                              onPressed: () {
                                _cameraBloc.add(ChangeFlashEvent());
                              },
                              icon: isFlashEnabled
                                  ? Assets.icons.icFlashEnable.svg()
                                  : Assets.icons.icFlashDisable.svg(),
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
                    padding: const EdgeInsets.only(
                      left: 20,
                      bottom: 20,
                      right: 20,
                    ),
                    height: 80,
                    child: NavigationToolbar(
                      leading: AppButton.icon(
                        onPressed: () {},
                        icon: Assets.icons.icAlbum.svg(width: 24, height: 24),
                      ),
                      middle: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surfaceContainerAlphaAlphaWhite17,
                        ),
                        height: 60,
                        width: 60,
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surfaceContainerGrayStrong0,
                          ),
                          height: 40,
                          width: 40,
                        ),
                      ),
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
