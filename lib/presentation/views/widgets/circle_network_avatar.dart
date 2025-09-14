import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';
import '../../resources/colors.dart';

class CircleNetworkAvatar extends StatelessWidget {
  const CircleNetworkAvatar({
    super.key,
    required this.imageUrl,
    this.size = 44,
    this.isGroupAvt = false,
  });

  final String imageUrl;
  final double size;
  final bool isGroupAvt;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: size / 2,
          backgroundColor: AppColors.surfaceContainerGrayStrong05,
          backgroundImage: imageProvider,
        ),
        placeholder: (_, _) => _buildPlaceholder(),
        errorWidget: (_, _, _) => _buildError(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    // TODO hoannk: Add placeholder
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: AppColors.surfaceContainerGrayStrong05,
      child: const Center(child: CupertinoActivityIndicator()),
    );
  }

  Widget _buildError() {
    // TODO hoannk: Add error
    return CircleAvatar(
      radius: size / 2,
      child: isGroupAvt
          ? Assets.images.imgDefaultGroupAvatar.image(
              width: size,
              height: size,
              fit: BoxFit.cover,
            )
          : Assets.icons.icDefaultAvatar.svg(
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
    );
  }
}
