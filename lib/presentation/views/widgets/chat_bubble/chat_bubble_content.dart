import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:ig_agency_app/shared/extensions/date_time_extension.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../domain/entities/message/message.dart';
import '../../../../shared/utils/text_message_display_util.dart';
import '../../../resources/colors.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../../shared/extensions/duration_ext.dart';
import '../../../../shared/extensions/int_ext.dart';
import '../network_image.dart';

const _kMaxHeightImageLinkPreview = 100.0;
const _kMaxHeightContentLinkPreview = 54.0;

class ChatBubbleContent extends StatelessWidget {
  const ChatBubbleContent({
    super.key,
    required this.message,
    required this.maxWidth,
    this.searchText,
    this.isMe = false,
  });

  final MessageEntity message;
  final double maxWidth;
  final String? searchText;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final content = message.content;
    switch (content) {
      case TextMessageContent _:
        return _TextMessageContent(
          textContent: content,
          createdAt: message.createdAt.toShortTimeString(),
          maxWidth: maxWidth,
          searchText: searchText,
          isMe: isMe,
        );
      case ImageMessageContent _:
        return _ImageMessageContent(imageContent: content);
      case VideoMessageContent _:
        return _VideoMessageContent(videoContent: content);
      case FileMessageContent _:
        return _FileMessageContent(fileContent: content, maxWidth: maxWidth);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _TextMessageContent extends StatelessWidget {
  const _TextMessageContent({
    required this.textContent,
    required this.createdAt,
    required this.maxWidth,
    this.searchText,
    this.isMe = false,
  });

  final TextMessageContent textContent;
  final String createdAt;
  final double maxWidth;
  final String? searchText;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: isMe
          ? AppColors.textDefaultTextInverted
          : AppColors.textDefaultTextDefault,
      fontSize: 16,
      fontFamily: FontFamily.segoeUI,
      fontWeight: FontWeight.w400,
      height: 1.50,
    );

    final (textSpans, _, link) = TextMessageDisplayUtil.parseTextContent(
      textContent,
      textStyle,
      searchText: searchText,
    );

    final isOnlyLink = link != null && link.length == textContent.text.length;

    if (isOnlyLink) {
      return Container(
        clipBehavior: Clip.antiAlias,
        constraints: BoxConstraints(maxWidth: maxWidth * 2 / 3),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerGrayStrong2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: _LinkPreview(url: link),
      );
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      constraints: BoxConstraints(
        maxWidth: link != null ? maxWidth * 2 / 3 : maxWidth,
      ),
      decoration: BoxDecoration(
        color: isMe
            ? AppColors.surfaceContainerSecondarySecondaryDefault
            : AppColors.surfaceContainerGrayStrong2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: link != null
          ? _buildContentWithLink(textSpans: textSpans, link: link)
          : _buildContentWithoutLink(textSpans: textSpans),
    );
  }

  Widget _buildContentWithLink({
    required List<TextSpan> textSpans,
    required String link,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: RichText(text: TextSpan(children: textSpans)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      createdAt,
                      style: TextStyle(
                        color: isMe
                            ? AppColors.textDefaultTextInverted
                            : AppColors.textDefaultTextSub2,
                        fontSize: 12,
                        fontFamily: FontFamily.segoeUI,
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _LinkPreview(url: link),
      ],
    );
  }

  Widget _buildContentWithoutLink({required List<TextSpan> textSpans}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: RichText(text: TextSpan(children: textSpans)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              createdAt,
              style: TextStyle(
                color: isMe
                    ? AppColors.textDefaultTextInverted
                    : AppColors.textDefaultTextSub2,
                fontSize: 12,
                fontFamily: FontFamily.segoeUI,
                fontWeight: FontWeight.w400,
                height: 1.33,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkPreview extends StatelessWidget {
  const _LinkPreview({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final isValidLink = AnyLinkPreview.isValidLink(url);

    if (!isValidLink) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        try {
          launchUrl(Uri.parse(url));
        } catch (e) {
          // TODO hoannk:
        }
      },
      child: AnyLinkPreview.builder(
        link: url,
        itemBuilder: (context, metadata, imageProvider, _) {
          final title = metadata.title;
          final description = metadata.desc;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageProvider != null && imageProvider is NetworkImage)
                SizedBox(
                  height: _kMaxHeightImageLinkPreview,
                  child: CachedNetworkImage(
                    imageUrl: imageProvider.url,
                    imageBuilder: (context, imageProvider) => Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      height: _kMaxHeightImageLinkPreview,
                      width: double.infinity,
                    ),
                    placeholder: (_, _) => Container(
                      height: _kMaxHeightImageLinkPreview,
                      width: double.infinity,
                      color: AppColors.surfaceContainerGrayStrong2,
                      child: const Center(child: CupertinoActivityIndicator()),
                    ),
                    errorWidget: (_, _, _) => Container(
                      height: _kMaxHeightImageLinkPreview,
                      width: double.infinity,
                      color: Color.fromARGB(255, 195, 197, 201),
                    ),
                  ),
                ),
              Container(
                height: _kMaxHeightContentLinkPreview,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerPrimaryPrimaryLight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? 'Title not found',
                      style: TextStyle(
                        color: AppColors.textDefaultTextDefault,
                        fontSize: 14,
                        fontFamily: FontFamily.segoeUI,
                        fontWeight: FontWeight.w700,
                        height: 1.43,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description ?? url,
                      style: TextStyle(
                        color: AppColors.textDefaultTextSub2,
                        fontSize: 12,
                        fontFamily: FontFamily.segoeUI,
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        placeholderWidget: Container(
          height: _kMaxHeightImageLinkPreview + _kMaxHeightContentLinkPreview,
          color: AppColors.surfaceContainerGrayStrong2,
          child: const Center(child: CupertinoActivityIndicator()),
        ),
        errorWidget: Container(
          height: _kMaxHeightImageLinkPreview + _kMaxHeightContentLinkPreview,
          color: Color.fromARGB(255, 195, 197, 201),
        ),
      ),
    );
  }
}

class _ImageMessageContent extends StatelessWidget {
  const _ImageMessageContent({required this.imageContent});

  final ImageMessageContent imageContent;

  @override
  Widget build(BuildContext context) {
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
  const _VideoMessageContent({required this.videoContent});

  final VideoMessageContent videoContent;

  @override
  Widget build(BuildContext context) {
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
  const _FileMessageContent({
    required this.fileContent,
    required this.maxWidth,
  });

  final FileMessageContent fileContent;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
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
