import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/work_place/list/workspace_list_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_pull_to_refresh.dart';
import 'package:ig_agency_app/shared/extensions/widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../../../domain/entities/workspace_entity.dart';
import '../../../../../../domain/enums/unmute_time_enum.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../../shared/commons/enums/status.dart';
import '../../../../../resources/colors.dart';
import '../../../../widgets/app_search_text_field.dart';
import '../../../../widgets/confirm_dialog.dart';
import '../../../../widgets/menu_dialog.dart';
import '../widgets/menu_popup_widget.dart';
import '../widgets/workspace_tile_widget.dart';

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
    return BlocSelector<WorkspaceListBloc, WorkspaceListState, bool>(
      selector: (state) {
        return state.isSearchMode;
      },
      builder: (context, state) {
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
                      return SuperMenuPopupWidget(
                        isMute: workspace.isMute,
                        isPin: workspace.isPin,
                        isSeen: workspace.isSeen,
                        onTapDelete: () async {
                          final result = await ConfirmDialog.show(
                            context,
                            title: "Delete this entire\nconversations?",
                            okText: "Delete",
                            cancelText: "Cancel",
                          );
                        },
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
                                  title: "Mute this chat?",
                                  items: UnMuteTimeEnum.values
                                      .map(
                                        (e) => MenuItem(
                                          content: e.title,
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
                        child: WorkspaceTileWidget(
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
            if (state)
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

                                  return SuperMenuPopupWidget(
                                    isMute: workspace.isMute,
                                    isPin: workspace.isPin,
                                    isSeen: workspace.isSeen,
                                    onTapDelete: () {},
                                    onTapMask: () {},
                                    onTapMute: () {},
                                    onTapPin: () {},
                                    child: WorkspaceTileWidget(
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        gradient: LinearGradient(
          colors: [Color(0xFFFFDC40), Color(0xFFFFBB33), Color(0xFFFF7E4D)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Workspace",
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
              child: AppSearchTextField(
                onSearchEnable: (value) {
                  _workspaceBloc.add(ToggleSearchEnableEvent());
                },
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
                hintText: "Nhập tên nhóm",
                // noBorder: true,
                suffixIcon: Assets.icons.icSearch.svg(
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    AppColors.iconDefaultDefaultSub,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
