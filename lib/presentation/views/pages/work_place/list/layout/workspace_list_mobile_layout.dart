import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/work_place/list/workspace_list_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_pull_to_refresh.dart';
import 'package:ig_agency_app/shared/extensions/widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../../../../../domain/entities/workspace_entity.dart';
import '../../../../../../domain/enums/unmute_time_enum.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../../shared/commons/enums/status.dart';
import '../../../../../resources/colors.dart';
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
  late RefreshController _refreshController;
  late RefreshController _searchRefreshController;

  late WorkspaceListBloc _workspaceBloc;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _searchRefreshController = RefreshController();

    _workspaceBloc = context.read<WorkspaceListBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkspaceListBloc, WorkspaceListState>(
      listener: (context, state) {
        _refreshController.refresh(state.pagingStatus);
      },
      listenWhen: (prev, curr) => prev.pagingStatus != curr.pagingStatus,
      child: BlocListener<WorkspaceListBloc, WorkspaceListState>(
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
            BlocSelector<
              WorkspaceListBloc,
              WorkspaceListState,
              List<WorkspaceEntity>
            >(
              selector: (state) {
                return state.workspaces;
              },
              builder: (context, state) {
                return AppPullToRefresh(
                  onLoadMore: () {
                    _workspaceBloc.add(LoadMoreDataEvent());
                  },
                  onRefresh: () {
                    _workspaceBloc.add(RefreshDataEvent());
                  },
                  refreshController: _refreshController,
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 4.5);
                    },
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final workspace = state[index];
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
                            final result =
                                await MenuDialog.show<UnMuteTimeEnum>(
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
                          onTap: () {},
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
                    itemCount: state.length,
                  ),
                );
              },
            ),
            if (searchModeState.isNotEmpty)
              BlocListener<WorkspaceListBloc, WorkspaceListState>(
                listener: (context, state) {
                  _searchRefreshController.refresh(state.pagingStatusSearch);
                },
                listenWhen: (prev, curr) =>
                    prev.pagingStatusSearch != curr.pagingStatusSearch,
                child:
                    BlocSelector<
                      WorkspaceListBloc,
                      WorkspaceListState,
                      (List<WorkspaceEntity>, PageStatus)
                    >(
                      selector: (state) {
                        return (state.workspacesSearch, state.searchStatus);
                      },
                      builder: (context, selected) {
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
                                itemBuilder: (context, index) {
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
                                      workspaceAvatar:
                                          workspace.workspaceAvatar,
                                      workspaceName: workspace.workspaceName,
                                      lastMessage: workspace.lastMessage,
                                      lastMessageTime:
                                          workspace.lastMessageTime,
                                      isSeen: workspace.isSeen,
                                      countNewMessage:
                                          workspace.countNewMessage,
                                    ),
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
              hintStyle: TextStyle(
                color: AppColors.textDefaultTextSub,
                fontSize: 16,
                fontFamily: FontFamily.segoeUI,
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
              hintText: "workspace.hint_text_search".tr(),
            );
          },
        ),
      ),
    );
  }
}
