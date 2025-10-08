import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/shared/extensions/date_time_extension.dart';
import 'package:ig_agency_app/shared/extensions/duration_ext.dart';
import 'package:ig_agency_app/shared/extensions/int_ext.dart';

import '../../../domain/entities/message/message.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/fonts.gen.dart';
import '../../../shared/utils/text_message_display_util.dart';
import '../ui_models/pinned_message_ui_model.dart';

import 'circle_network_avatar.dart';
import 'network_image.dart';

class PinnedMessageBubble extends StatelessWidget {
  const PinnedMessageBubble({
    super.key,
    required this.message,
    this.onTap,
    this.onLongPress,
    this.hasArrow = false,
  });

  final PinnedMessageUIModel message;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool hasArrow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      onLongPress: onLongPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 12,
        children: [
          CircleNetworkAvatar(imageUrl: message.userAvatar, size: 24),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Flexible(
                        child: Text(
                          message.userName,
                          style: TextStyle(
                            color: AppColors.textDefaultTextSub2,
                            fontSize: 14,
                            fontFamily: FontFamily.segoeUI,
                            fontWeight: FontWeight.w700,
                            height: 1.14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '•',
                        style: TextStyle(
                          color: AppColors.textDefaultTextSub2,
                          fontSize: 14,
                          fontFamily: FontFamily.segoeUI,
                          fontWeight: FontWeight.w400,
                          height: 1.14,
                        ),
                      ),
                      Text(
                        message.createdAt.formatDateWithTime(),
                        style: TextStyle(
                          color: AppColors.textDefaultTextSub2,
                          fontSize: 14,
                          fontFamily: FontFamily.segoeUI,
                          fontWeight: FontWeight.w400,
                          height: 1.14,
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _buildPinnedMessageContent(),
                    Positioned(
                      left: -10,
                      top: -10,
                      child: Assets.icons.icPinned.svg(width: 20, height: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (hasArrow)
            Assets.icons.icArrowRightThin.svg(width: 24, height: 24),
        ],
      ),
    );
  }

  Widget _buildPinnedMessageContent() {
    final content = message.content;
    switch (content) {
      case TextMessageContent _:
        final textStyle = const TextStyle(
          color: AppColors.textDefaultTextDefault,
          fontSize: 16,
          fontFamily: FontFamily.segoeUI,
          fontWeight: FontWeight.w400,
          height: 1.50,
        );

        final (textSpans, hostName, _) =
            TextMessageDisplayUtil.parseTextContent(content, textStyle);
        return _PinnedMessageText(textSpans: textSpans, hostName: hostName);
      case ImageMessageContent _:
        return _PinnedMessageImage(
          imageUrl: content.imageUrl,
          width: content.width,
          height: content.height,
        );
      case VideoMessageContent _:
        return _PinnedMessageVideo(
          imageUrl: content.thumbnailUrl ?? '',
          width: content.width,
          height: content.height,
          duration: content.duration,
        );
      case FileMessageContent _:
        return _PinnedMessageFile(
          fileFullName: content.fileName,
          fileSize: content.fileSize,
        );
      case StickerMessageContent _:
        return _PinnedMessageSticker(
          stickerUrl: content.stickerUrl,
          width: content.width,
          height: content.height,
        );
      default:
        return SizedBox.shrink();
    }
  }
}

class _PinnedMessageText extends StatelessWidget {
  const _PinnedMessageText({required this.textSpans, required this.hostName});

  final List<TextSpan>? textSpans;
  final String? hostName;

  @override
  Widget build(BuildContext context) {
    final hostName = this.hostName;
    return Container(
      padding: const EdgeInsets.only(top: 4, left: 12, right: 12, bottom: 8),
      decoration: ShapeDecoration(
        color: AppColors.surfaceContainerGrayStrong2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(text: TextSpan(children: textSpans)),
          if (hostName != null && hostName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              hostName,
              style: TextStyle(
                color: AppColors.textDefaultTextDefault,
                fontSize: 16,
                fontFamily: FontFamily.segoeUI,
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PinnedMessageImage extends StatelessWidget {
  const _PinnedMessageImage({required this.imageUrl, this.width, this.height});

  final String imageUrl;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return NetworkImageWidget(
      imageUrl: imageUrl,
      originalWidth: width,
      originalHeight: height,
      borderRadius: BorderRadius.circular(12),
      backgroundColor: AppColors.surfaceContainerGrayStrong2,
    );
  }
}

class _PinnedMessageVideo extends StatelessWidget {
  const _PinnedMessageVideo({
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.duration,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return NetworkImageWidget(
      imageUrl: imageUrl,
      originalWidth: width,
      originalHeight: height,
      borderRadius: BorderRadius.circular(12),
      imageBuilder: (context, imageProvider) => Stack(
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: Image(image: imageProvider),
          ),
          Positioned(right: 8, bottom: 8, child: _buildDurationChip(duration)),
          Align(
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: ShapeDecoration(
                color: AppColors.surfaceContainerAlphaAlphaBlack37,
                shape: const CircleBorder(),
              ),
              child: Assets.icons.icPlaySize30.svg(width: 30, height: 30),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.surfaceContainerGrayStrong2,
    );
  }

  Widget _buildDurationChip(Duration duration) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: ShapeDecoration(
        color: AppColors.surfaceContainerAlphaAlphaBlack37,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(9999)),
        ),
      ),
      child: Text(
        duration.toVideoDurationString(),
        textAlign: TextAlign.right,
        style: TextStyle(
          color: AppColors.textNeutralWhite,
          fontSize: 12,
          fontFamily: FontFamily.segoeUI,
          fontWeight: FontWeight.w600,
          height: 1.33,
        ),
      ),
    );
  }
}

class _PinnedMessageFile extends StatelessWidget {
  const _PinnedMessageFile({
    required this.fileFullName,
    required this.fileSize,
  });

  final String fileFullName;
  final int fileSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: AppColors.surfaceContainerGrayStrong2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 8,
        children: [
          Assets.icons.icCircleDocumentPrimary.svg(width: 24, height: 24),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  fileFullName,
                  style: TextStyle(
                    color: AppColors.textDefaultTextDefault,
                    fontSize: 14,
                    fontFamily: FontFamily.segoeUI,
                    fontWeight: FontWeight.w700,
                    height: 1.43,
                  ),
                ),
                Text(
                  fileSize.toFileSizeString(),
                  style: TextStyle(
                    color: AppColors.textDefaultTextSub2,
                    fontSize: 12,
                    fontFamily: FontFamily.segoeUI,
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PinnedMessageSticker extends StatelessWidget {
  const _PinnedMessageSticker({
    required this.stickerUrl,
    required this.width,
    required this.height,
  });

  final String stickerUrl;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(); // TODO hoannk
  }
}
