import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/work_place/list/workspace_list_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_pull_to_refresh.dart';
import 'package:ig_agency_app/shared/extensions/widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../../routers/app_router.dart';

class WorkspaceListMobileLayout extends StatefulWidget {
  const WorkspaceListMobileLayout({super.key});

  @override
  State<WorkspaceListMobileLayout> createState() =>
      _WorkspaceListMobileLayoutState();
}

class _WorkspaceListMobileLayoutState extends State<WorkspaceListMobileLayout> {
  late RefreshController _refreshController;

  late WorkspaceListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _bloc = context.read<WorkspaceListBloc>();
    _bloc.add(LoadDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkspaceListBloc, WorkspaceListState>(
      listener: (context, state) {
        _refreshController.refresh(state.pagingStatus);
      },
      listenWhen: (pre, cur) => pre.pagingStatus != pre.pagingStatus,
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: SafeArea(
          child: AppPullToRefresh(
            refreshController: _refreshController,
            onLoadMore: () {},
            onRefresh: () {},
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              alignment: Alignment.center,
              child: GestureDetector(
                child: Text('List'),
                onTap: () {
                  context.router.push(WSDetailRoute());
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
