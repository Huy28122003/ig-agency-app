import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/views/pages/fowrard/widgets/forward_tile.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_pull_to_refresh.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_search_text_field.dart';
import 'package:ig_agency_app/shared/extensions/widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

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
  late final RefreshController _refreshController;
  late final RefreshController _searchRefreshController;
  late final ForwardBloc _forwardBloc;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _searchRefreshController = RefreshController();
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
    return BlocListener<ForwardBloc, ForwardState>(
      listener: (context, state) {
        _refreshController.refresh(state.pagingStatus);
      },
      listenWhen: (prev, curr) => prev.pagingStatus != curr.pagingStatus,
      child: BlocSelector<ForwardBloc, ForwardState, List<WorkspaceEntity>>(
        selector: (state) {
          return state.workspaces;
        },
        builder: (context, state) {
          return AppPullToRefresh(
            enablePullDown: false,
            onLoadMore: () {
              _forwardBloc.add(GetDataEvent());
            },
            refreshController: _refreshController,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox();
              },
              itemBuilder: (context, index) {
                return ForwardTile(workspaceEntity: state[index]);
              },
              itemCount: state.length,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchMode() {
    return BlocListener<ForwardBloc, ForwardState>(
      listener: (context, state) {
        _searchRefreshController.refresh(state.searchPagingStatus);
      },
      listenWhen: (prev, curr) =>
          prev.searchPagingStatus != curr.searchPagingStatus,
      child: BlocSelector<ForwardBloc, ForwardState, List<WorkspaceEntity>>(
        selector: (state) {
          return state.workspacesSearch;
        },
        builder: (context, state) {
          return AppPullToRefresh(
            enablePullDown: false,
            onLoadMore: () {
              _forwardBloc.add(GetSearchDataEvent());
            },
            refreshController: _searchRefreshController,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ForwardTile(workspaceEntity: state[index]);
              },
              itemCount: state.length,
            ),
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
            "Send to",
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
                "Done",
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
            hintText: "Tìm kiếm",
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
}
