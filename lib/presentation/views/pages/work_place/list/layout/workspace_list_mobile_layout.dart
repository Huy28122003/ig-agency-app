import 'package:auto_route/auto_route.dart';
import 'package:card_loading/card_loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/work_place/list/workspace_list_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_list_view.dart';
import '../../../../../../domain/entities/workspace_entity.dart';
import '../../../../../../domain/enums/unmute_time_enum.dart';
import '../../../../../../shared/commons/enums/status.dart';
import '../../../../../resources/colors.dart';
import '../../../../../routers/app_router.dart';
import '../../../../widgets/app_search_text_field.dart';
import '../../../../widgets/header_home_view.dart';
import '../../../../widgets/menu_dialog.dart';
import '../widgets/menu_popup_mobile_widget.dart';
import '../widgets/workspace_tile_mobile_widget.dart';

class WorkspaceListMobileLayout extends StatefulWidget {
  const WorkspaceListMobileLayout({super.key});

  @override
  State<WorkspaceListMobileLayout> createState() =>
      _WorkspaceListMobileLayoutState();
}

class _WorkspaceListMobileLayoutState extends State<WorkspaceListMobileLayout> {
  late WorkspaceListBloc _workspaceBloc;

  @override
  void initState() {
    super.initState();

    _workspaceBloc = context.read<WorkspaceListBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkspaceListBloc, WorkspaceListState>(
      listener: (context, state) {
        if (state.pageStatus == PageStatus.failure) {
          // todo
        }
      },
      listenWhen: (prev, curr) => prev.pageStatus != curr.pageStatus,
      child: Container(
        color: AppColors.surfaceContainerGrayStrong0,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocSelector<WorkspaceListBloc, WorkspaceListState, String>(
      selector: (state) {
        return state.searchKeyWord;
      },
      builder: (context, searchModeState) {
        return Stack(
          children: [
            _buildNormalModel(),
            if (searchModeState.isNotEmpty) _buildSearchMode(),
            Positioned(
              bottom: 22,
              right: 20,
              child: SizedBox(
                height: 56,
                width: 56,
                child: FloatingActionButton(
                  elevation: 1.5,
                  shape: const CircleBorder(),
                  backgroundColor: AppColors.primary,
                  onPressed: () {
                    context.router.push(const CreateGroupRoute());
                  },
                  child: Icon(Icons.add, color: Colors.white, size: 32),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNormalModel() {
    return BlocBuilder<WorkspaceListBloc, WorkspaceListState>(
      buildWhen: (pre, cur) {
        return pre.pagingStatus != cur.pagingStatus ||
            pre.workspaces != cur.workspaces;
      },
      builder: (context, state) {
        return AppListView(
          padding: EdgeInsets.zero,
          cardLoading: _buildLoading(),
          numCardLoading: 6,
          fetchStatus: state.pagingStatus,
          onLoadMore: () {
            _workspaceBloc.add(LoadMoreDataEvent());
          },
          onRefresh: () {
            _workspaceBloc.add(RefreshDataEvent());
          },
          data: state.workspaces,
          builder: (_, index) {
            final workspace = state.workspaces[index];
            return SuperMenuPopupMobileWidget(
              isMute: workspace.isMute,
              isPin: workspace.isPin,
              isSeen: workspace.isSeen,
              onTapDelete: () async {},
              onTapMask: () {
                _workspaceBloc.add(
                  SeenWorkspaceEvent(workspaceId: workspace.id),
                );
              },
              onTapMute: () async {
                if (workspace.isMute) {
                  final result = await MenuDialog.show<UnMuteTimeEnum>(
                    onTap: (value) {},
                    context: context,
                    title: "workspace.mute_title".tr(),
                    items: UnMuteTimeEnum.values
                        .map(
                          (e) => MenuItem(
                            content: 'workspace.${e.title}'.tr(),
                            value: e,
                          ),
                        )
                        .toList(),
                  );
                }
                _workspaceBloc.add(
                  MuteWorkspaceEvent(workspaceId: workspace.id),
                );
              },
              onTapPin: () {
                _workspaceBloc.add(
                  PinWorkspaceEvent(workspaceId: workspace.id),
                );
              },
              child: WorkspaceTileMobileWidget(
                onTap: () {
                  context.router.push(GroupInfoRoute());
                },
                isMute: workspace.isMute,
                isPin: workspace.isPin,
                workspaceAvatar: workspace.workspaceAvatar,
                workspaceName: workspace.workspaceName,
                lastMessage: workspace.lastMessage,
                lastMessageTime: workspace.lastMessageTime,
                isSeen: workspace.isSeen,
                countNewMessage: workspace.countNewMessage,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchMode() {
    return BlocSelector<
      WorkspaceListBloc,
      WorkspaceListState,
      (List<WorkspaceEntity>, PageStatus, PagingStatus)
    >(
      selector: (state) {
        return (
          state.workspacesSearch,
          state.searchStatus,
          state.pagingStatusSearch,
        );
      },
      builder: (context, selected) {
        final workspaces = selected.$1;
        final status = selected.$2;
        final pagingStatus = selected.$3;
        if (status == PageStatus.loading) {
          return CupertinoActivityIndicator();
        } else if (status == PageStatus.loaded) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: AppListView(
              padding: EdgeInsets.zero,
              cardLoading: _buildLoading(),
              numCardLoading: 6,
              fetchStatus: pagingStatus,
              enablePullDown: false,
              onLoadMore: () {
                _workspaceBloc.add(SearchLoadMoreEvent());
              },
              builder: (_, index) {
                final workspace = workspaces[index];

                return SuperMenuPopupMobileWidget(
                  isMute: workspace.isMute,
                  isPin: workspace.isPin,
                  isSeen: workspace.isSeen,
                  onTapDelete: () {},
                  onTapMask: () {},
                  onTapMute: () {},
                  onTapPin: () {},
                  child: WorkspaceTileMobileWidget(
                    onTap: () {},
                    isSearchMode: true,
                    isMute: workspace.isMute,
                    isPin: workspace.isPin,
                    workspaceAvatar: workspace.workspaceAvatar,
                    workspaceName: workspace.workspaceName,
                    lastMessage: workspace.lastMessage,
                    lastMessageTime: workspace.lastMessageTime,
                    isSeen: workspace.isSeen,
                    countNewMessage: workspace.countNewMessage,
                  ),
                );
              },
              data: workspaces,
            ),
          );
        }
        return SizedBox();
      },
    );
  }

  Widget _buildHeader() {
    return HeaderHomeView(
      title: "workspace.workspace".tr(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: BlocSelector<WorkspaceListBloc, WorkspaceListState, String>(
          selector: (state) {
            return state.searchKeyWord;
          },
          builder: (context, state) {
            return AppSearchTextField(
              value: state,
              onChanged: (value) {
                _workspaceBloc.add(SearchKeyWorkChangeEvent(value: value));
                _workspaceBloc.add(SearchEvent(value: value));
              },
              hintText: "workspace.hint_text_search".tr(),
            );
          },
        ),
      ),
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
