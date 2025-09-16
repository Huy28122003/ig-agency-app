import 'package:flutter/material.dart';
import 'package:ig_agency_app/shared/extensions/datetime_ext.dart';
import '../../../../domain/entities/message/message.dart';
import '../../../../shared/utils/text_message_display_util.dart';
import '../../../resources/colors.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../../shared/extensions/duration_ext.dart';
import '../../../../shared/extensions/int_ext.dart';
import '../network_image.dart';

class ChatBubbleContent extends StatelessWidget {
  const ChatBubbleContent({
    super.key,
    required this.message,
    required this.maxWidth,
  });

  final MessageEntity message;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    if (message.isText) {
      return _TextMessageContent(message: message, maxWidth: maxWidth);
    }

    if (message.isImage) {
      return _ImageMessageContent(message: message);
    }

    if (message.isVideo) {
      return _VideoMessageContent(message: message);
    }

    if (message.isFile) {
      return _FileMessageContent(message: message, maxWidth: maxWidth);
    }

    return const SizedBox.shrink();
  }
}

class _TextMessageContent extends StatelessWidget {
  const _TextMessageContent({required this.message, required this.maxWidth});

  final MessageEntity message;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(
      color: AppColors.textDefaultTextDefault,
      fontSize: 16,
      fontFamily: FontFamily.segoeUI,
      fontWeight: FontWeight.w400,
      height: 1.50,
    );

    final (textSpans, _, link) = TextMessageDisplayUtil.parseTextContent(
      message.content,
      textStyle,
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      constraints: BoxConstraints(maxWidth: maxWidth),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerGrayStrong2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: RichText(text: TextSpan(children: textSpans)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        message.createdAt.toShortTimeString(),
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
          ),
          if (link != null) ...[
            // Link preview implementation can be added here
            const SizedBox.shrink(),
          ],
        ],
      ),
    );
  }
}

class _ImageMessageContent extends StatelessWidget {
  const _ImageMessageContent({required this.message});

  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final imageContent = message.content as ImageMessageContent;

    return NetworkImageWidget(
      imageUrl: imageContent.imageUrl,
      originalWidth: imageContent.width,
      originalHeight: imageContent.height,
      borderRadius: BorderRadius.circular(12),
      backgroundColor: AppColors.surfaceContainerGrayStrong2,
    );
  }
}

class _VideoMessageContent extends StatelessWidget {
  const _VideoMessageContent({required this.message});

  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final videoContent = message.content as VideoMessageContent;

    return NetworkImageWidget(
      imageUrl: videoContent.thumbnailUrl ?? '',
      originalWidth: videoContent.width,
      originalHeight: videoContent.height,
      borderRadius: BorderRadius.circular(12),
      imageBuilder: (context, imageProvider) => Stack(
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: Image(image: imageProvider),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: _buildDurationChip(videoContent.duration),
          ),
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

class _FileMessageContent extends StatelessWidget {
  const _FileMessageContent({required this.message, required this.maxWidth});

  final MessageEntity message;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final fileContent = message.content as FileMessageContent;

    return Container(
      clipBehavior: Clip.antiAlias,
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: ShapeDecoration(
        color: AppColors.surfaceContainerPrimaryPrimaryLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Assets.icons.icCircleDocumentPrimary.svg(width: 24, height: 24),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${fileContent.fileName}.${fileContent.fileExtension}',
                  style: const TextStyle(
                    color: AppColors.textDefaultTextDefault,
                    fontSize: 14,
                    fontFamily: FontFamily.segoeUI,
                    fontWeight: FontWeight.w700,
                    height: 1.43,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fileContent.fileSize.toFileSizeString(),
                  style: const TextStyle(
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
