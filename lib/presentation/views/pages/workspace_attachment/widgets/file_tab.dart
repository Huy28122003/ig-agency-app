import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/file_entity.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/views/pages/workspace_attachment/bloc/workspace_attachment_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_pull_to_refresh.dart';
import 'package:ig_agency_app/shared/extensions/widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../../gen/assets.gen.dart';

class FileTab extends StatefulWidget {
  const FileTab({super.key});

  @override
  State<FileTab> createState() => _FileTabState();
}

class _FileTabState extends State<FileTab> {
  late final RefreshController _refreshController;
  late final WorkspaceAttachmentBloc _workspaceAttachmentBloc;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _workspaceAttachmentBloc = context.read<WorkspaceAttachmentBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkspaceAttachmentBloc, WorkspaceAttachmentState>(
      listener: (context, state) {
        _refreshController.refresh(state.mediaPagingStatus);
      },
      listenWhen: (prev, curr) =>
          prev.mediaPagingStatus != curr.mediaPagingStatus,
      child:
          BlocSelector<
            WorkspaceAttachmentBloc,
            WorkspaceAttachmentState,
            List<FileEntity>
          >(
            selector: (state) {
              return state.files;
            },
            builder: (context, state) {
              return AppPullToRefresh(
                enablePullDown: false,
                onLoadMore: () {
                  _workspaceAttachmentBloc.add(GetFilesEvent());
                },
                refreshController: _refreshController,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    return FileItem(fileEntity: state[index]);
                  },
                  itemCount: state.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 8);
                  },
                ),
              );
            },
          ),
    );
  }
}

class FileItem extends StatelessWidget {
  const FileItem({super.key, required this.fileEntity});

  final FileEntity fileEntity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerGrayStrong1,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Assets.icons.icCircleDocumentPrimary.svg(width: 24, height: 24),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileEntity.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    height: 20 / 14,
                    fontFamily: FontFamily.segoeUI,
                    color: AppColors.textDefaultTextDefault,
                  ),
                ),
                Text(
                  "${fileEntity.size.toStringAsFixed(2)} MB",
                  style: TextStyle(
                    fontFamily: FontFamily.segoeUI,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 16 / 12,
                    color: AppColors.textDefaultTextSub2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
