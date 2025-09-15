import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/media_detail/bloc/media_detail_bloc.dart';
import '../../../../resources/colors.dart';

class ImageWidget extends StatefulWidget {
  final bool isFullScreenMode;
  final int imageIndex;

  const ImageWidget({
    super.key,
    required this.isFullScreenMode,
    required this.imageIndex,
  });

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  late final MediaDetailBloc _mediaDetailBloc;

  @override
  void initState() {
    super.initState();
    _mediaDetailBloc = context.read<MediaDetailBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.isFullScreenMode)
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
              _mediaDetailBloc.medias[widget.imageIndex].previewUrl,
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
            _mediaDetailBloc.add(ChangeImageViewModeEvent());
          },
          child: Image.network(
            width: double.infinity,
            _mediaDetailBloc.medias[widget.imageIndex].previewUrl,
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
