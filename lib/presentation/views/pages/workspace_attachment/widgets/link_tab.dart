import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/models/meta_data_link.dart';
import 'package:ig_agency_app/shared/extensions/widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../widgets/app_pull_to_refresh.dart';
import '../bloc/workspace_attachment_bloc.dart';

class LinkTab extends StatefulWidget {
  const LinkTab({super.key});

  @override
  State<LinkTab> createState() => _LinkTabState();
}

class _LinkTabState extends State<LinkTab> {
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
        _refreshController.refresh(state.linkPagingStatus);
      },
      listenWhen: (prev, curr) =>
          prev.linkPagingStatus != curr.linkPagingStatus,
      child:
          BlocSelector<
            WorkspaceAttachmentBloc,
            WorkspaceAttachmentState,
            List<MetaDataLink>
          >(
            selector: (state) {
              return state.links;
            },
            builder: (context, state) {
              return AppPullToRefresh(
                refreshController: _refreshController,
                enablePullDown: false,
                onLoadMore: () {
                  _workspaceAttachmentBloc.add(GetLinksEvent());
                },
                child: ListView.separated(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    return LinkItem(
                      metaDataLink: state[index],
                      onTap: () {
                        _workspaceAttachmentBloc.add(
                          OpenLinkEvent(index: index),
                        );
                      },
                    );
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

class LinkItem extends StatelessWidget {
  final MetaDataLink metaDataLink;
  final VoidCallback onTap;

  const LinkItem({super.key, required this.metaDataLink, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              metaDataLink.title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                height: 20 / 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "${metaDataLink.url} - ${metaDataLink.description}",
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                height: 16 / 12,
                color: Colors.black54,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
