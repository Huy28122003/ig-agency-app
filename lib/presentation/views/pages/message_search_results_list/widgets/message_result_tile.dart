import 'package:flutter/material.dart';
import 'package:ig_agency_app/domain/entities/message/message.dart';
import 'package:ig_agency_app/shared/extensions/date_time_extension.dart';

import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';
import '../../../widgets/circle_network_avatar.dart';

class MessageResultTile extends StatelessWidget {
  final MessageEntity message;
  final String messageSearch;

  const MessageResultTile({
    super.key,
    required this.message,
    required this.messageSearch,
  });

  @override
  Widget build(BuildContext context) {
    final content = (message.content as TextMessageContent).text;

    return GestureDetector(
      onTap: () {},
      child: Container(
        color: AppColors.surfaceBackgroundBackground,
        padding: const EdgeInsets.only(left: 20, top: 8, right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleNetworkAvatar(
                  imageUrl: message.user.avatar,
                  isGroupAvt: true,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.user.avatar,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    height: 26 / 18,
                                    color: AppColors.textDefaultTextDefault,
                                    fontFamily: FontFamily.segoeUI,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                _buildMessageResult(content),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.outlineGrayStrong200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageResult(String content) {
    final listWord = content.split(' ');
    final messageSearchIndex = listWord.indexWhere((e) => e == messageSearch);

    List<String> shortlist = [];
    if (messageSearchIndex != -1) {
      shortlist = listWord.sublist(
        (messageSearchIndex - 2).clamp(0, listWord.length),
        (messageSearchIndex + 3).clamp(0, listWord.length),
      );
    } else {
      shortlist = List.from(listWord);
    }

    return Row(
      children: [
        Flexible(
          child: Text.rich(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            TextSpan(
              children: shortlist
                  .map(
                    (e) => TextSpan(
                      text: '$e ',
                      style: TextStyle(
                        fontFamily: FontFamily.segoeUI,
                        fontSize: 14,
                        height: 20 / 14,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: e == messageSearch
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.textDefaultTextSub2,
          ),
          width: 4,
          height: 4,
        ),
        const SizedBox(width: 4),
        Text(
          message.createdAt.convertDateTimeToString(),
          style: TextStyle(
            fontFamily: FontFamily.segoeUI,
            fontSize: 14,
            height: 20 / 14,
          ),
        ),
      ],
    );
  }
}
