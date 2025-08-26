import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/views/pages/workspace/widgets/menu_popup_widget.dart';
import 'package:ig_agency_app/presentation/views/pages/workspace/widgets/workspace_tile_widget.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_pull_to_refresh.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_text_field.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:ig_agency_app/shared/extensions/widget.dart';
import 'package:ig_agency_app/shared/mock_data.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../bloc/workspace_bloc.dart';

class WorkspaceMobileLayout extends StatefulWidget {
  const WorkspaceMobileLayout({super.key});

  @override
  State<WorkspaceMobileLayout> createState() => _WorkspaceMobileLayoutState();
}

class _WorkspaceMobileLayoutState extends State<WorkspaceMobileLayout> {
  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkspaceBloc, WorkspaceState>(
      listener: (context, state) {
        _refreshController.refresh(PagingStatus.loadCompleted);
      },
      listenWhen: (prev, curr) => prev.pageStatus != curr.pageStatus,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return AppPullToRefresh(
      onLoadMore: () {
        print("fdsf");
      },
      onRefresh: () {
        print("fdsf");
      },
      refreshController: _refreshController,
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final workspace = MockData.getWorkspaces()[index];
          return SuperMenuPopupWidget(
            onTapDelete: () {},
            onTapMask: () {},
            onTapMute: () {},
            onTapPin: () {},
            child: WorkspaceTileWidget(
              workspaceAvatar: workspace.workspaceAvatar,
              workspaceName: workspace.workspaceName,
              lastMessage: workspace.lastMessage,
              lastMessageTime: workspace.lastMessageTime,
              isSeen: workspace.isSeen,
            ),
          );
        },
        itemCount: MockData.getWorkspaces().length,
      ),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: AppTextField(
                onChanged: (value) {},
                hintStyle: TextStyle(
                  color: AppColors.textDefaultTextSub,
                  fontSize: 16,
                  fontFamily: FontFamily.segoeUI,
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                ),
                hintText: "Nhập tên nhóm",
                noBorder: true,
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
