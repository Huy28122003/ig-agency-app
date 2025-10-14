import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/work_place/list/widgets/workspace_tile_tablet_widget.dart';
import 'package:ig_agency_app/presentation/views/pages/work_place/list/workspace_list_bloc.dart';
import 'package:ig_agency_app/shared/extensions/widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../../../../../domain/entities/group_summary.dart';
import '../../../../../../domain/enums/unmute_time_enum.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../../shared/commons/enums/status.dart';
import '../../../../../resources/colors.dart';
import '../../../../../routers/app_router.dart';
import '../../../../widgets/app_pull_to_refresh.dart';
import '../../../../widgets/app_search_text_field.dart';
import '../../../../widgets/menu_dialog.dart';
import '../widgets/menu_popup_tablet_widget.dart';

class WorkspaceListTabletLayout extends StatefulWidget {
  const WorkspaceListTabletLayout({super.key});

  @override
  State<WorkspaceListTabletLayout> createState() =>
      _WorkspaceListTabletLayoutState();
}

class _WorkspaceListTabletLayoutState extends State<WorkspaceListTabletLayout> {
  late RefreshController _searchRefreshController;
  late RefreshController _refreshController;
  late GroupListBloc _workspaceBloc;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _searchRefreshController = RefreshController();

    _workspaceBloc = context.read<GroupListBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupListBloc, GroupListState>(
      listener: (_, state) {
        _refreshController.refresh(state.pagingStatus);
      },
      listenWhen: (prev, curr) => prev.pagingStatus != curr.pagingStatus,
      child: BlocListener<GroupListBloc, GroupListState>(
        listener: (_, state) {
          if (state.pageStatus == PageStatus.failure) {
            // todo
          }
        },
        listenWhen: (prev, curr) => prev.pageStatus != curr.pageStatus,
        child: Container(
          padding: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xFFFF7E4C),
            const Color(0xFFFFBA32),
            const Color(0xFFFFDB3F),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              child: Text(
                "workspace.workspace".tr(),
                style: TextStyle(
                  fontFamily: FontFamily.segoeUI,
                  color: AppColors.textDefaultTextInverted,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  height: 40 / 32,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 12,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: BlocSelector<GroupListBloc, GroupListState, String>(
                selector: (state) {
                  return state.searchKeyWord;
                },
                builder: (_, state) {
                  return AppSearchTextField(
                    value: state,
                    onSearchEnable: (value) {},
                    onChanged: (value) {
                      _workspaceBloc.add(
                        SearchKeyWorkChangeEvent(value: value),
                      );
                      _workspaceBloc.add(SearchEvent(value: value));
                    },
                    hintText: "workspace.hint_text_search".tr(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocSelector<GroupListBloc, GroupListState, bool>(
      selector: (searchModeState) {
        return searchModeState.isSearchMode;
      },
      builder: (_, searchModeState) {
        return Stack(
          children: [
            BlocSelector<GroupListBloc, GroupListState, List<GroupSummary>>(
              selector: (state) {
                return state.workspaces;
              },
              builder: (_, state) {
                return AppPullToRefresh(
                  onLoadMore: () {
                    _workspaceBloc.add(LoadMoreDataEvent());
                  },
                  onRefresh: () {
                    _workspaceBloc.add(RefreshDataEvent());
                  },
                  refreshController: _refreshController,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    separatorBuilder: (_, index) {
                      return SizedBox(height: 4);
                    },
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (_, index) {
                      final workspace = state[index];
                      return BlocSelector<
                        GroupListBloc,
                        GroupListState,
                        String?
                      >(
                        selector: (state) {
                          return state.workspaceSelectedId;
                        },
                        builder: (context, state) {
                          return SuperMenuPopupTabletWidget(
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
                                await MenuDialog.show<UnMuteTimeEnum>(
                                  onTap: (value) {},
                                  context: context,
                                  title: "workspace.unmute_title".tr(),
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
                            child: WorkspaceTileTabletWidget(
                              onTap: () {
                                _workspaceBloc.add(
                                  SelectWorkspaceEvent(id: workspace.id),
                                );
                                context.router.replaceAll([
                                  WSDetailRoute(
                                    groupId: "1", // TODO hoannk: change id
                                    groupName: workspace.name,
                                    groupAvatar: workspace.avatar,
                                  ),
                                ]);
                              },
                              isMute: workspace.isMute,
                              isPin: workspace.isPin,
                              workspaceAvatar: workspace.avatar,
                              workspaceName: workspace.name,
                              lastMessage: workspace.lastMessage,
                              lastMessageTime: workspace.lastMessageTime,
                              isSeen: workspace.isSeen,
                              countNewMessage: 0,
                              isSelected:
                                  (state != null && state == workspace.id),
                            ),
                          );
                        },
                      );
                    },
                    itemCount: state.length,
                  ),
                );
              },
            ),
            if (searchModeState)
              BlocListener<GroupListBloc, GroupListState>(
                listener: (_, state) {
                  _searchRefreshController.refresh(state.pagingStatusSearch);
                },
                listenWhen: (prev, curr) =>
                    prev.pagingStatusSearch != curr.pagingStatusSearch,
                child:
                    BlocSelector<
                      GroupListBloc,
                      GroupListState,
                      (List<GroupSummary>, PageStatus)
                    >(
                      selector: (state) {
                        return (state.workspacesSearch, state.searchStatus);
                      },
                      builder: (_, selected) {
                        final workspaces = selected.$1;
                        final status = selected.$2;
                        if (status == PageStatus.loading) {
                          return CupertinoActivityIndicator();
                        } else if (status == PageStatus.loaded) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.white,
                            child: AppPullToRefresh(
                              enablePullDown: true,
                              onLoadMore: () {
                                _workspaceBloc.add(SearchLoadMoreEvent());
                              },
                              refreshController: _searchRefreshController,
                              child: ListView.builder(
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (_, index) {
                                  final workspace = workspaces[index];

                                  return BlocSelector<
                                    GroupListBloc,
                                    GroupListState,
                                    String?
                                  >(
                                    selector: (state) {
                                      return state.workspaceSelectedId;
                                    },
                                    builder: (context, state) {
                                      return SuperMenuPopupTabletWidget(
                                        isMute: workspace.isMute,
                                        isPin: workspace.isPin,
                                        isSeen: workspace.isSeen,
                                        onTapDelete: () {},
                                        onTapMask: () {},
                                        onTapMute: () {},
                                        onTapPin: () {},
                                        child: WorkspaceTileTabletWidget(
                                          onTap: () {
                                            _workspaceBloc.add(
                                              SelectWorkspaceEvent(
                                                id: workspace.id,
                                              ),
                                            );
                                          },
                                          isMute: workspace.isMute,
                                          isPin: workspace.isPin,
                                          workspaceAvatar: workspace.avatar,
                                          workspaceName: workspace.name,
                                          lastMessage: workspace.lastMessage,
                                          lastMessageTime:
                                              workspace.lastMessageTime,
                                          isSeen: workspace.isSeen,
                                          countNewMessage: 0,
                                          isSelected:
                                              (state != null &&
                                              state == workspace.id),
                                        ),
                                      );
                                    },
                                  );
                                },
                                itemCount: workspaces.length,
                              ),
                            ),
                          );
                        }
                        return SizedBox();
                      },
                    ),
              ),
          ],
        );
      },
    );
  }
}
