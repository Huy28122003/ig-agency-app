import 'package:auto_route/auto_route.dart';
import 'package:card_loading/card_loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/views/pages/fowrard/widgets/forward_tile.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_list_view.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_search_text_field.dart';

import '../../../../di/di.dart';
import 'bloc/forward_bloc.dart';

class ForwardBottomSheet extends StatefulWidget {
  const ForwardBottomSheet({super.key});

  static Future<void> show(BuildContext context, {required String messageId}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) => getIt<ForwardBloc>()..add(LoadDataEvent()),
        child: ForwardBottomSheet(),
      ),
    );
  }

  @override
  State<ForwardBottomSheet> createState() => _ForwardBottomSheetState();
}

class _ForwardBottomSheetState extends State<ForwardBottomSheet> {
  late final ForwardBloc _forwardBloc;

  @override
  void initState() {
    super.initState();
    _forwardBloc = context.read<ForwardBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceBackgroundBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: EdgeInsets.only(top: 9),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 8),
            _buildTextField(),
            SizedBox(height: 8),
            Expanded(
              child: BlocSelector<ForwardBloc, ForwardState, String>(
                selector: (state) {
                  return state.searchKeyWord;
                },
                builder: (context, state) {
                  return Stack(
                    children: [
                      _buildNormalMode(),
                      if (state.isNotEmpty) _buildSearchMode(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNormalMode() {
    return Container(
      child: BlocBuilder<ForwardBloc, ForwardState>(
        buildWhen: (prev, curr) =>
            prev.workspaces != curr.workspaces ||
            prev.pagingStatus != curr.pagingStatus,
        builder: (context, state) {
          return AppListView(
            padding: EdgeInsets.zero,
            fetchStatus: state.pagingStatus,
            enablePullDown: false,
            onLoadMore: () {
              _forwardBloc.add(GetDataEvent());
            },
            data: state.workspaces,
            builder: (context, index) {
              return ForwardTile(workspaceEntity: state.workspaces[index]);
            },
            cardLoading: _buildLoading(),
            separatorBuilder: (_, index) {
              return SizedBox();
            },
            numCardLoading: 6,
          );
        },
      ),
    );
  }

  Widget _buildSearchMode() {
    return Container(
      color: AppColors.surfaceBackgroundBackground,
      child: BlocBuilder<ForwardBloc, ForwardState>(
        buildWhen: (prev, curr) =>
            prev.searchPagingStatus != curr.searchPagingStatus ||
            prev.workspacesSearch != curr.workspacesSearch,
        builder: (context, state) {
          return AppListView(
            padding: EdgeInsets.zero,
            fetchStatus: state.searchPagingStatus,
            enablePullDown: false,
            onLoadMore: () {
              _forwardBloc.add(
                SearchDebouncedEvent(_forwardBloc.state.searchKeyWord),
              );
            },
            data: state.workspacesSearch,
            builder: (data, int index) {
              return ForwardTile(
                workspaceEntity: state.workspacesSearch[index],
              );
            },
            cardLoading: _buildLoading(),
            separatorBuilder: (_, index) {
              return SizedBox();
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(child: SizedBox()),
        Center(
          child: Text(
            "general.send_to".tr(),
            style: TextStyle(
              fontSize: 16,
              height: 24 / 16,
              fontFamily: FontFamily.segoeUI,
              fontWeight: FontWeight.w700,
              color: AppColors.textDefaultTextDefault,
            ),
          ),
        ),

        Expanded(
          child: GestureDetector(
            onTap: () {
              context.router.pop();
            },
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Text(
                "general.done".tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.segoeUI,
                  fontSize: 16,
                  height: 24 / 16,
                  color: AppColors.textAlertTextInfo,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return BlocSelector<ForwardBloc, ForwardState, String>(
      selector: (state) {
        return state.searchKeyWord;
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: AppSearchTextField(
            onChanged: (value) {
              _forwardBloc.add(ChangeKeyWordEvent(value: value));
              _forwardBloc.add(SearchEvent(value: value));
            },
            value: state,
            hintText: "general.search".tr(),
            fillColor: AppColors.surfaceContainerGrayStrong1,
            hintStyle: TextStyle(
              color: AppColors.textDefaultTextSub,
              fontSize: 14,
              height: 20 / 14,
              fontFamily: FontFamily.segoeUI,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardLoading(
                height: 48,
                borderRadius: BorderRadius.all(Radius.circular(1000)),
                width: 48,
                margin: EdgeInsets.only(bottom: 10),
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
                              CardLoading(
                                height: 25,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 10),
                              ),
                              const SizedBox(height: 6),
                              CardLoading(
                                height: 20,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                width: 150,
                                margin: EdgeInsets.only(bottom: 10),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        CardLoading(
                          height: 20,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          width: 80,
                          margin: EdgeInsets.only(bottom: 10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
