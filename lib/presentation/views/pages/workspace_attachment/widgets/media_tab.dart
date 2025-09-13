import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/media_entity.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';
import 'package:ig_agency_app/presentation/views/pages/workspace_attachment/bloc/workspace_attachment_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_pull_to_refresh.dart';
import 'package:ig_agency_app/shared/extensions/duration_ext.dart';
import 'package:ig_agency_app/shared/extensions/widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class MediaTab extends StatefulWidget {
  const MediaTab({super.key});

  @override
  State<MediaTab> createState() => _MediaTabState();
}

class _MediaTabState extends State<MediaTab> {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child:
                BlocSelector<
                  WorkspaceAttachmentBloc,
                  WorkspaceAttachmentState,
                  int
                >(
                  selector: (state) {
                    return state.totalMedia;
                  },
                  builder: (context, state) {
                    return Text(
                      '${'attachment.all_media'.tr()} ($state)',
                      style: TextStyle(
                        fontFamily: FontFamily.segoeUI,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 24 / 16,
                        color: AppColors.textDefaultTextSub2,
                      ),
                    );
                  },
                ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child:
                BlocSelector<
                  WorkspaceAttachmentBloc,
                  WorkspaceAttachmentState,
                  List<MediaEntity>
                >(
                  selector: (state) {
                    return state.medias;
                  },
                  builder: (context, state) {
                    return AppPullToRefresh(
                      refreshController: _refreshController,
                      enablePullDown: false,
                      onLoadMore: () {
                        _workspaceAttachmentBloc.add(GetMediasEvent());
                      },
                      child: GridView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: MediaItem(mediaEntity: state[index]),
                            onTap: () {
                              context.router.push(
                                MediaDetailRoute(
                                  url: state[index].previewUrl,
                                  isVideo: state[index].isVideo,
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
          ),
        ],
      ),
    );
  }
}

class MediaItem extends StatelessWidget {
  const MediaItem({super.key, required this.mediaEntity});

  final MediaEntity mediaEntity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(9)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              fit: BoxFit.cover,
              mediaEntity.previewUrl,
              errorBuilder: (context, _, _) {
                return Placeholder();
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return const Center(child: CupertinoActivityIndicator());
              },
            ),
          ),
          if (mediaEntity.duration != null)
            Positioned(
              right: 7,
              bottom: 4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerAlphaAlphaBlack37,
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: Text(
                  mediaEntity.duration!.toVideoDurationString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: FontFamily.segoeUI,
                    fontSize: 12,
                    height: 16 / 12,
                    color: AppColors.textNeutralWhite,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
