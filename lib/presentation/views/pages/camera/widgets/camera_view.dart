import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../camera_bloc.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return BlocSelector<CameraBloc, CameraState, CameraStatus>(
          selector: (state) => state.status,
          builder: (context, status) {
            final cameraController = context.read<CameraBloc>().controller;
            final previewSize = cameraController?.value.previewSize;
            if (!status.isReady ||
                cameraController == null ||
                previewSize == null) {
              return SizedBox();
            }
            final aspectRatio = constraints.maxWidth / constraints.maxHeight;

            final cameraAspectRatio = previewSize.height / previewSize.width;

            return ClipRect(
              child: Transform.scale(
                scale: cameraAspectRatio / aspectRatio,
                child: Center(child: CameraPreview(cameraController)),
              ),
            );
          },
        );
      },
    );
  }
}
