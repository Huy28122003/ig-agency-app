import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../domain/entities/message/message_entity.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../../../../../routers/app_router.dart';
import '../workspace_detail_bloc.dart';

class SearchResultsBar extends StatelessWidget {
  const SearchResultsBar({super.key, required this.groupName});

  final String groupName;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<WSDetailBloc>();
    return BlocBuilder<WSDetailBloc, WSDetailState>(
      buildWhen: (prev, curr) =>
      prev.indexSearchMessage != curr.indexSearchMessage ||
          prev.messageSearchResults != curr.messageSearchResults,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerGrayStrong3,
          ),
          child: SafeArea(
            child: Row(
              children: [
                Assets.icons.icSearch.svg(
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
                SizedBox(width: 12),
                BlocSelector<WSDetailBloc, WSDetailState, String>(
                  selector: (state) {
                    return state.searchKeyword;
                  },
                  builder: (context, state) {
                    if (state.isEmpty) {
                      return Text(
                        textAlign: TextAlign.start,
                        "search.no_result".tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 20 / 14,
                          fontFamily: FontFamily.segoeUI,
                          color: AppColors.textDefaultTextSub2,
                        ),
                      );
                    }
                    return BlocSelector<
                        WSDetailBloc,
                        WSDetailState,
                        (int, List<MessageEntity>)
                    >(
                      selector: (state) {
                        return (
                        state.indexSearchMessage,
                        state.messageSearchResults,
                        );
                      },
                      builder: (context, state) {
                        final index = state.$1;
                        final total = state.$2.length;
                        return Text(
                          textAlign: TextAlign.start,
                          "${index + 1} of $total",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            height: 20 / 14,
                            fontFamily: FontFamily.segoeUI,
                            color: AppColors.textDefaultTextSub2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    );
                  },
                ),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    if (bloc.state.messageSearchResults.isEmpty) return;
                    final messageId = await context.router.push<String>(
                      MessageSearchResultsListRoute(
                        workspaceId: bloc.groupId,
                        searchMessage: bloc.state.searchKeyword,
                        workspaceName: groupName,
                      ),
                    );
                    if (messageId == null) return;
                    bloc.add(JumpToMessageEvent(messageId: messageId));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "search.show_as_list".tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: FontFamily.segoeUI,
                        fontSize: 16,
                        height: 24 / 16,
                        color: AppColors.iconAlertInfo,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}