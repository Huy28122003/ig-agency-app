import 'package:flutter/material.dart';
import 'package:ig_agency_app/shared/extensions/duration_ext.dart';
import 'package:ig_agency_app/shared/extensions/int_ext.dart';
import '../../../../domain/entities/message/message.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../../shared/utils/text_message_display_util.dart';
import '../../../resources/colors.dart';
import '../circle_network_avatar.dart';
import '../network_image.dart';

class ChatMessageBubble extends StatefulWidget {
  const ChatMessageBubble({
    super.key,
    required this.maxWidth,
    required this.horizontalPadding,
    required this.isOwnMessage,
    required this.message,
  });

  final double maxWidth;
  final MessageEntity message;
  final double horizontalPadding;
  final bool isOwnMessage;

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  late MessageEntity _message;

  @override
  void initState() {
    super.initState();
    _message = widget.message;
  }

  @override
  Widget build(BuildContext context) {
    final MessageReply? reply = _message.reply;
    final bool hasReply = reply != null;
    return GestureDetector(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!widget.isOwnMessage) ...[
            CircleNetworkAvatar(imageUrl: _message.sender.avatarUrl, size: 32),
            SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: widget.isOwnMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!widget.isOwnMessage) ...[
                  if (hasReply) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            _message.sender.name,
                            style: TextStyle(
                              color: AppColors.textDefaultTextSub2,
                              fontSize: 12,
                              fontFamily: FontFamily.segoeUI,
                              fontWeight: FontWeight.w600,
                              height: 1.33,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          ' replying to ',
                          style: TextStyle(
                            color: AppColors.textDefaultTextSub2,
                            fontSize: 12,
                            fontFamily: FontFamily.segoeUI,
                            fontWeight: FontWeight.w600,
                            height: 1.33,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            reply.senderName,
                            style: TextStyle(
                              color: AppColors.textDefaultTextSub2,
                              fontSize: 12,
                              fontFamily: FontFamily.segoeUI,
                              fontWeight: FontWeight.w700,
                              height: 1.33,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else
                    Text(
                      _message.sender.name,
                      style: TextStyle(
                        color: AppColors.textDefaultTextSub2,
                        fontSize: 12,
                        fontFamily: FontFamily.segoeUI,
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                  SizedBox(height: 4),
                ],
                _buildMessageContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    if (_message.isText) {
      final textStyle = const TextStyle(
        color: AppColors.textDefaultTextDefault,
        fontSize: 16,
        fontFamily: FontFamily.segoeUI,
        fontWeight: FontWeight.w400,
        height: 1.50,
      );

      final (textSpans, _, link) = TextMessageDisplayUtil.parseTextContent(
        _message.content,
        textStyle,
      );
      return _MessageText(
        textSpans: textSpans,
        link: link,
        maxWidth: widget.maxWidth,
      );
    }

    if (_message.isImage) {
      final imageContent = _message.content as ImageMessageContent;
      return _MessageImage(
        imageUrl: imageContent.imageUrl,
        width: imageContent.width,
        height: imageContent.height,
      );
    }

    if (_message.isVideo) {
      final videoContent = _message.content as VideoMessageContent;
      return _MessageVideo(
        imageUrl: videoContent.thumbnailUrl ?? '',
        width: videoContent.width,
        height: videoContent.height,
        duration: videoContent.duration,
      );
    }

    if (_message.isFile) {
      final fileContent = _message.content as FileMessageContent;
      return _MessageFile(
        fileFullName: '${fileContent.fileName}.${fileContent.fileExtension}',
        fileSize: fileContent.fileSize,
        maxWidth: widget.maxWidth,
      );
    }

    return SizedBox.shrink();
  }
}

class _MessageText extends StatelessWidget {
  const _MessageText({
    required this.textSpans,
    required this.link,
    this.maxWidth,
  });

  final List<TextSpan>? textSpans;
  final String? link;
  final double? maxWidth;

  bool isNotEmpty(String? str) {
    return str != null &&
        str.trim().isNotEmpty &&
        str.trim().toLowerCase() != 'null';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      constraints: maxWidth != null
          ? BoxConstraints(maxWidth: maxWidth!)
          : null,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 4,
              left: 12,
              right: 12,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerGrayStrong2,
            ),
            child: RichText(text: TextSpan(children: textSpans)),
          ),
          if (link != null) ...[
            // AnyLinkPreview.builder(
            //   link: link!,
            //   itemBuilder: (context, item, image, svg) {
            //     final title = isNotEmpty(item.title) ? item.title : null;
            //     final desc = isNotEmpty(item.desc) ? item.desc : null;

            //     if (title != null && desc != null) {
            //       return Column(
            //         mainAxisSize: MainAxisSize.min,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           // Image or SVG
            //           if (image != null) ...[],
            //           if (svg != null) ...[],
            //           Container(
            //             padding: const EdgeInsets.symmetric(
            //               horizontal: 12,
            //               vertical: 8,
            //             ),
            //             clipBehavior: Clip.antiAlias,
            //             decoration: BoxDecoration(
            //               color: AppColors.surfaceContainerPrimaryPrimaryLight,
            //             ),
            //             child: Column(
            //               mainAxisSize: MainAxisSize.min,
            //               spacing: 2,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   title,
            //                   style: TextStyle(
            //                     color: AppColors.textDefaultTextDefault,
            //                     fontSize: 14,
            //                     fontFamily: FontFamily.segoeUI,
            //                     fontWeight: FontWeight.w700,
            //                     height: 1.43,
            //                   ),
            //                   maxLines: 2,
            //                   overflow: TextOverflow.ellipsis,
            //                 ),
            //                 Text(
            //                   desc,
            //                   style: TextStyle(
            //                     color: AppColors.textDefaultTextSub2,
            //                     fontSize: 12,
            //                     fontFamily: FontFamily.segoeUI,
            //                     fontWeight: FontWeight.w400,
            //                     height: 1.33,
            //                   ),
            //                   maxLines: 4,
            //                   overflow: TextOverflow.ellipsis,
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       );
            //     }
            //     return SizedBox();
            //   },
            // ),
          ],
        ],
      ),
    );
  }
}

class _MessageImage extends StatelessWidget {
  const _MessageImage({required this.imageUrl, this.width, this.height});

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

class _MessageVideo extends StatelessWidget {
  const _MessageVideo({
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
          Positioned(right: 8, bottom: 8, child: _buidlDurationChip()),
          Align(
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: ShapeDecoration(
                color: AppColors.surfaceContainerAlphaAlphaBlack37,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(75),
                ),
              ),
              child: Assets.icons.icPlaySize30.svg(width: 30, height: 30),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.surfaceContainerGrayStrong2,
    );
  }

  Widget _buidlDurationChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: ShapeDecoration(
        color: AppColors.surfaceContainerAlphaAlphaBlack37,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
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

class _MessageFile extends StatelessWidget {
  const _MessageFile({
    required this.fileFullName,
    required this.fileSize,
    this.maxWidth,
  });

  final String fileFullName;
  final int fileSize;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      constraints: maxWidth != null
          ? BoxConstraints(maxWidth: maxWidth!)
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: ShapeDecoration(
        color: AppColors.surfaceContainerPrimaryPrimaryLight,
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
