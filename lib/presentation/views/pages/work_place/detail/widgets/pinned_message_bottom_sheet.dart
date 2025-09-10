import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/shared/extensions/widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../workspace_detail_bloc.dart';
import '../../../../widgets/app_pull_to_refresh.dart';
import '../../../../widgets/pinned_message_bubble.dart';

class PinnedMessagesBottomSheet extends StatefulWidget {
  const PinnedMessagesBottomSheet({super.key, required this.onTap});

  final Function(String messageId) onTap;

  @override
  State<PinnedMessagesBottomSheet> createState() =>
      _PinnedMessagesBottomSheetState();
}

class _PinnedMessagesBottomSheetState extends State<PinnedMessagesBottomSheet> {
  late final WSDetailBloc _bloc;
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<WSDetailBloc>();
    _refreshController = RefreshController();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _showOptionSheet(BuildContext context, String messageId) async {
    final result = await showCupertinoModalPopup<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.68),
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              'Unpin',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.colorsBlue,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                height: 1.29,
                letterSpacing: -0.43,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(
            'Cancel',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.colorsBlue,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              height: 1.29,
              letterSpacing: -0.43,
            ),
          ),
        ),
      ),
    );

    if (result == true) {
      _bloc.add(UnpinMessageFromDetailEvent(messageId: messageId));
    }
  }

  void _onRefresh() {
    _bloc.add(RefreshPinnedMessagesEvent());
  }

  void _onLoadMore() {
    _bloc.add(LoadMorePinnedMessagesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<WSDetailBloc, WSDetailState>(
          listenWhen: (previous, current) =>
              previous.pinnedMessagesPagingStatus !=
              current.pinnedMessagesPagingStatus,
          listener: (context, state) {
            _refreshController.refresh(state.pinnedMessagesPagingStatus);
          },
        ),
        BlocListener<WSDetailBloc, WSDetailState>(
          listenWhen: (previous, current) =>
              previous.isUnpinSuccess != current.isUnpinSuccess,
          listener: (context, state) {
            if (state.isUnpinSuccess) {
              _bloc.add(GetPinnedMessageSummaryEvent());
              _bloc.add(ResetUnpinSuccessEvent());
            }
          },
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 4),
            width: 36,
            height: 5,
            decoration: ShapeDecoration(
              color: AppColors.labelsTertiary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.50),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Pinned messages',
                style: TextStyle(
                  color: AppColors.textDefaultTextDefault,
                  fontSize: 16,
                  fontFamily: FontFamily.segoeUI,
                  fontWeight: FontWeight.w700,
                  height: 1.50,
                ),
              ),
            ),
          ),
          Flexible(
            child: SafeArea(
              top: false,
              child: BlocBuilder<WSDetailBloc, WSDetailState>(
                buildWhen: (previous, current) =>
                    previous.pinnedMessages != current.pinnedMessages,
                builder: (context, state) {
                  if (state.pinnedMessages.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return AppPullToRefresh(
                    refreshController: _refreshController,
                    onRefresh: _onRefresh,
                    onLoadMore: _onLoadMore,
                    child: ListView.separated(
                      padding: EdgeInsets.all(20),
                      itemBuilder: (context, index) {
                        final message = state.pinnedMessages[index];

                        return PinnedMessageBubble(
                          key: ValueKey(message.id),
                          message: message,
                          hasArrow: true,
                          onTap: () {
                            final messageId = message.id;
                            if (messageId == null) return;
                            widget.onTap(messageId);
                          },
                          onLongPress: () {
                            final messageId = message.id;
                            if (messageId == null) return;
                            _showOptionSheet(context, messageId);
                          },
                        );
                      },
                      separatorBuilder: (_, _) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Divider(
                          color: AppColors.outlineGrayStrong200,
                          height: 2,
                        ),
                      ),
                      itemCount: state.pinnedMessages.length,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
