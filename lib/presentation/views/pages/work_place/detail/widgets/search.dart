import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        final goToUpEnable =
            state.indexSearchMessage < bloc.state.totalSearchMessage - 1 &&
                bloc.state.totalSearchMessage != 0;
        final goToDownEnable =
            state.indexSearchMessage > 0 && bloc.state.totalSearchMessage != 0;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                if (!goToUpEnable) return;
                bloc.add(GoToMessageEvent(isGoUp: true));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.only(right: 12),
                  width: 26,
                  height: 26,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (goToUpEnable)
                        ? AppColors.iconPrimaryDefault
                        : AppColors.iconPrimaryDisable,
                  ),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Assets.icons.icArrowLeft.svg(),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!goToDownEnable) return;
                bloc.add(GoToMessageEvent());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.only(right: 12),
                  width: 26,
                  height: 26,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (goToDownEnable)
                        ? AppColors.iconPrimaryDefault
                        : AppColors.iconPrimaryDisable,
                  ),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Assets.icons.icArrowLeft.svg(),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerGrayStrong3,
              ),
              child: Row(
                children: [
                  Assets.icons.icSearch.svg(
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 12),
                  BlocSelector<WSDetailBloc, WSDetailState, (int, int)>(
                    selector: (state) {
                      return (
                      state.indexSearchMessage,
                      state.totalSearchMessage,
                      );
                    },
                    builder: (context, state) {
                      final index = state.$1;
                      final total = state.$2;
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
                      );
                    },
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      context.router.push(
                        MessageSearchResultsListRoute(
                          workspaceId: bloc.groupId,
                          searchMessage: bloc.state.searchKeyword,
                          workspaceName: groupName,
                        ),
                      );
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
          ],
        );
      },
    );
  }
}

