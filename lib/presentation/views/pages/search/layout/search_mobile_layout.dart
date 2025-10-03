import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/views/pages/search/search_bloc.dart';
import 'package:ig_agency_app/shared/extensions/widget.dart';

import '../../../../../domain/entities/search.dart';
import '../../../../../domain/enums/filter_type.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../routers/app_router.dart';
import '../../../widgets/app_list_view.dart';
import '../../../widgets/app_search_text_field.dart';
import '../../../widgets/circle_network_avatar.dart';
import '../../../widgets/header_home_view.dart';
import '../widgets/search_group_card_loading.dart';

class SearchMobileLayout extends StatelessWidget {
  const SearchMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackgroundBackground,
      body: Column(
        children: [
          HeaderHomeView(
            title: 'Search',
            child: BlocSelector<SearchBloc, SearchState, String>(
              selector: (SearchState state) => state.textSearch,
              builder: (context, textSearch) {
                return AppSearchTextField(
                  value: textSearch,
                  onChanged: (value) {
                    context.read<SearchBloc>().add(SearchTextChanged(value));
                  },
                  hintText: 'Search',
                  onSearchEnable: (enable) {
                    context.read<SearchBloc>().add(ShowResultChanged(enable));
                  },
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              buildWhen: (pre, cur) {
                return pre.textSearch.isEmpty && cur.textSearch.isNotEmpty ||
                    pre.textSearch.isNotEmpty && cur.textSearch.isEmpty;
              },
              builder: (context, state) {
                if (state.textSearch.isEmpty) {
                  return SizedBox();
                }
                return _buildBodySearchWidget(10);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodySearchWidget(int numCardLoading) {
    return Column(
      children: [
        BlocSelector<SearchBloc, SearchState, FilterType>(
          selector: (state) => state.filterType,
          builder: (context, filterType) {
            return _buildFilterList(filterType, (type) {
              context.read<SearchBloc>().add(FilterTypeChanged(type));
            });
          },
        ),
        BlocBuilder<SearchBloc, SearchState>(
          buildWhen: (pre, cur) {
            return pre.pagingStatus != cur.pagingStatus ||
                pre.results != cur.results;
          },
          builder: (context, state) {
            return Expanded(
              child: AppListView(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                enablePullDown: false,
                data: state.results,
                builder: (_, index) {
                  final result = state.results[index];
                  if (state.filterType == FilterType.message) {
                    return _buildMessageResult(result: result, onTap: () {});
                  }
                  return _buildGroupResult(
                    result: result,
                    onTap: () {
                      context.router.push(
                        WSDetailRoute(
                          groupId: result.groupInfo.id,
                          groupName: result.groupInfo.name,
                          groupAvatar: result.groupInfo.avatar,
                        ),
                      );
                    },
                  );
                },
                fetchStatus: state.pagingStatus,
                separatorBuilder: (_, _) => Container(
                  color: AppColors.outlineGrayStrong200,
                  height: 1,
                  margin: EdgeInsets.only(left: 56),
                ),
                cardLoading: SearchGroupCardLoading(),
                numCardLoading: numCardLoading,
                onLoadMore: () {
                  context.read<SearchBloc>().add(LoadMoreResult());
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFilterList(
    FilterType selectedType,
    ValueChanged<FilterType> onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: List.generate(FilterType.values.length, (index) {
          final type = FilterType.values[index];
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap.call(type),
              child: _buildFilterItem(
                title: type.name,
                isSelected: selectedType == type,
              ),
            ),
          );
        }).withSpaceBetween(width: 12),
      ),
    );
  }

  Widget _buildFilterItem({required String title, required bool isSelected}) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: isSelected
            ? AppColors.surfaceContainerSecondarySecondaryDefault
            : AppColors.outlineGrayStrong200,
      ),
      alignment: Alignment.center,
      child: Text(
        "search.$title".tr(),
        style: TextStyle(
          color: isSelected
              ? AppColors.textDefaultTextInverted
              : AppColors.textDefaultTextDefault,
          fontSize: 16,
          fontFamily: FontFamily.segoeUI,
          fontWeight: FontWeight.w600,
          height: 24 / 16,
        ),
      ),
    );
  }

  Widget _buildGroupResult({
    required SearchResult result,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            CircleNetworkAvatar(
              imageUrl: result.groupInfo.avatar,
              size: 48,
              isGroupAvt: true,
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                result.groupInfo.name,
                style: TextStyle(
                  color: AppColors.textDefaultTextDefault,
                  fontSize: 16,
                  fontFamily: FontFamily.segoeUI,
                  fontWeight: FontWeight.w600,
                  height: 24 / 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageResult({
    required SearchResult result,
    required VoidCallback onTap,
  }) {
    final userInfo = result.userInfo;
    final message = result.message;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            CircleNetworkAvatar(
              imageUrl: result.groupInfo.avatar,
              size: 48,
              isGroupAvt: true,
            ),
            SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      result.groupInfo.name,
                      style: TextStyle(
                        color: AppColors.textDefaultTextDefault,
                        fontSize: 16,
                        fontFamily: FontFamily.segoeUI,
                        fontWeight: FontWeight.w600,
                        height: 24 / 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 2),
                  if (userInfo != null)
                    Row(
                      children: [
                        CircleNetworkAvatar(
                          imageUrl: userInfo.avatar,
                          size: 12,
                        ),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            userInfo.name,
                            style: TextStyle(
                              color: AppColors.textDefaultTextDefault,
                              fontSize: 12,
                              fontFamily: FontFamily.segoeUI,
                              fontWeight: FontWeight.w600,
                              height: 14 / 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(width: 2),
                  if (message != null)
                    Flexible(
                      child: Text(
                        message.message,
                        style: TextStyle(
                          color: AppColors.textDefaultTextDefault,
                          fontSize: 12,
                          fontFamily: FontFamily.segoeUI,
                          fontWeight: FontWeight.w600,
                          height: 14 / 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
