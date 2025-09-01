import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/shared/extensions/datetime_ext.dart';
import 'package:ig_agency_app/shared/extensions/duration_ext.dart';
import 'package:ig_agency_app/shared/extensions/int_ext.dart';

import '../../../domain/entities/message/message.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/fonts.gen.dart';
import '../../../shared/utils/text_message_display_util.dart';
import '../models/pinned_message_ui_model.dart';

import 'circle_network_avatar.dart';
import 'network_image.dart';

class PinnedMessageBubble extends StatefulWidget {
  const PinnedMessageBubble({
    super.key,
    required this.message,
    required this.onTap,
  });

  final PinnedMessageUIModel message;
  final VoidCallback onTap;

  @override
  State<PinnedMessageBubble> createState() => _PinnedMessageBubbleState();
}

class _PinnedMessageBubbleState extends State<PinnedMessageBubble> {
  late PinnedMessageUIModel _message;

  @override
  void initState() {
    super.initState();
    _message = widget.message;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 12,
        children: [
          CircleNetworkAvatar(imageUrl: _message.senderAvatarUrl, size: 24),
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
                          _message.senderName,
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
                        _message.pinnedAt.toShortDateString(),
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
                    GestureDetector(
                      onTap: widget.onTap,
                      child: _buildPinnedMessageContent(),
                    ),
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
        ],
      ),
    );
  }

  Widget _buildPinnedMessageContent() {
    if (_message.isText) {
      final textStyle = const TextStyle(
        color: AppColors.textDefaultTextDefault,
        fontSize: 16,
        fontFamily: FontFamily.segoeUI,
        fontWeight: FontWeight.w400,
        height: 1.50,
      );

      final (textSpans, hostName) = TextMessageDisplayUtil.parseTextContent(
        _message.content,
        textStyle,
      );
      return _PinnedMessageText(textSpans: textSpans, hostName: hostName);
    }

    if (_message.isImage) {
      final imageContent = _message.content as ImageMessageContent;
      return _PinnedMessageImage(
        imageUrl: imageContent.imageUrl,
        width: imageContent.width,
        height: imageContent.height,
      );
    }

    if (_message.isVideo) {
      final videoContent = _message.content as VideoMessageContent;
      return _PinnedMessageVideo(
        imageUrl: videoContent.thumbnailUrl ?? '',
        width: videoContent.width,
        height: videoContent.height,
        duration: videoContent.duration,
      );
    }

    if (_message.isFile) {
      final fileContent = _message.content as FileMessageContent;

      return _PinnedMessageFile(
        fileFullName: '${fileContent.fileName}.${fileContent.fileExtension}',
        fileSize: fileContent.fileSize,
      );
    }

    return SizedBox.shrink();
  }
}

class _PinnedMessageText extends StatelessWidget {
  const _PinnedMessageText({required this.textSpans, required this.hostName});

  final List<TextSpan>? textSpans;
  final String? hostName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          if (hostName != null) ...[
            const SizedBox(height: 4),
            Text(
              hostName!,
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
    this.width,
    this.height,
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
          Positioned(right: 7, bottom: 4, child: _buidlDurationChip()),
          Align(
            child: Icon(
              Icons.play_circle_filled,
              color: AppColors.textNeutralWhite,
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.surfaceContainerGrayStrong2,
    );
  }

  Widget _buidlDurationChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: ShapeDecoration(
        color: AppColors.surfaceContainerAlphaAlphaBlack37,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          Text(
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
        ],
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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: AppColors.surfaceContainerGrayStrong2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 8,
        children: [
          Assets.icons.icCircleDocumentPrimary.svg(width: 24, height: 24),
          Expanded(
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
