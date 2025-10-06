import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../resources/colors.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.maxWidth = 240,
    this.maxHeight = 240,
    this.originalWidth,
    this.originalHeight,
    this.backgroundColor,
    this.imageBuilder,
    this.borderRadius,
  });

  final String imageUrl;
  final double? originalWidth;
  final double? originalHeight;
  final double maxWidth;
  final double maxHeight;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveMaxWidth =
            constraints.maxWidth > 0 && constraints.maxWidth < maxWidth
            ? constraints.maxWidth
            : maxWidth;
        final effectiveMaxHeight =
            constraints.maxHeight > 0 && constraints.maxHeight < maxHeight
            ? constraints.maxHeight
            : maxHeight;

        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: borderRadius),
          constraints: BoxConstraints(
            maxWidth: effectiveMaxWidth,
            maxHeight: effectiveMaxHeight,
          ),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => (imageBuilder != null)
                ? _buildBackground(
                    effectiveMaxWidth,
                    effectiveMaxHeight,
                    child:
                        imageBuilder?.call(context, imageProvider) ??
                        SizedBox.shrink(),
                  )
                // : FittedBox(
                //     fit: BoxFit.contain,
                //     child: Image(image: imageProvider),
                //   ),
                : _buildBackground(
                    effectiveMaxWidth,
                    effectiveMaxHeight,
                    child: Image(image: imageProvider, fit: BoxFit.cover,),
                  ),
            placeholder: (_, _) =>
                _buildPlaceholder(effectiveMaxWidth, effectiveMaxHeight),
            errorWidget: (_, _, _) =>
                _buildError(effectiveMaxWidth, effectiveMaxHeight),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder(double maxWidth, double maxHeight) {
    return _buildBackground(
      maxWidth,
      maxHeight,
      child: const Center(child: CupertinoActivityIndicator()),
    );
  }

  Widget _buildError(double maxWidth, double maxHeight) {
    return _buildBackground(
      maxWidth,
      maxHeight,
      child: const Center(
        child: Icon(Icons.error, color: AppColors.textAlertTextError),
      ),
    );
  }

  Widget _buildBackground(
    double maxWidth,
    double maxHeight, {
    required Widget child,
  }) {
    double containerWidth = maxWidth;
    double containerHeight = maxHeight;

    if (originalWidth != null && originalHeight != null) {
      double aspectRatio = originalWidth! / originalHeight!;
      containerHeight = containerWidth / aspectRatio;

      if (containerHeight > maxHeight) {
        containerHeight = maxHeight;
        containerWidth = containerHeight * aspectRatio;
      } else if (containerWidth > maxWidth) {
        containerWidth = maxWidth;
        containerHeight = containerWidth / aspectRatio;
      }
    }

    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: backgroundColor ?? AppColors.surfaceContainerGrayStrong05,
      ),
      child: child,
    );
  }
}
