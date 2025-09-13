import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/media_detail/bloc/media_detail_bloc.dart';

import '../../../../resources/colors.dart';

class ImageWidget extends StatelessWidget {
  final bool isFullScreenMode;

  const ImageWidget({super.key, required this.isFullScreenMode});

  @override
  Widget build(BuildContext context) {
    return (isFullScreenMode)
        ? _buildFullScreenMode(context)
        : _buildNormalMode(context);
  }

  Widget _buildNormalMode(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: GestureDetector(
          onTap: () {
            context.read<MediaDetailBloc>().add(ChangeImageViewModeEvent());
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              width: double.infinity,
              context.read<MediaDetailBloc>().url,
              fit: BoxFit.fill,
              errorBuilder: (context, _, _) {
                return SizedBox();
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return const Center(child: CupertinoActivityIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullScreenMode(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.surfaceContainerGrayStrong95,
      child: Center(
        child: GestureDetector(
          onTap: () {
            context.read<MediaDetailBloc>().add(ChangeImageViewModeEvent());
          },
          child: Image.network(
            width: double.infinity,
            context.read<MediaDetailBloc>().url,
            fit: BoxFit.cover,
            errorBuilder: (context, _, _) {
              return SizedBox();
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return const Center(child: CupertinoActivityIndicator());
            },
          ),
        ),
      ),
    );
  }
}
