import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/shared/extensions/widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../../../di/di.dart';
import '../../../../../../domain/usecases/message/unpin_message_use_case.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../../domain/usecases/message/fetch_pinned_message_in_group_use_case.dart';
import '../../../../../../shared/commons/enums/status.dart';
import '../../../../../resources/colors.dart';
import '../../../../widgets/app_pull_to_refresh.dart';
import '../../../../widgets/pinned_message_bubble.dart';
import '../../../../../cubits/pinned_message_bottom_sheet/pinned_message_bottom_sheet_cubit.dart';

class PinnedMessagesBottomSheet extends StatefulWidget {
  const PinnedMessagesBottomSheet({super.key, this.onTap, this.onUnpinSuccess});

  final VoidCallback? onUnpinSuccess;
  final Function(String messageId)? onTap;

  static Future<void> show(
    BuildContext context,
    int groupId, {
    required VoidCallback onUnpinSuccess,
    required Function(String messageId) onTap,
  }) async {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      elevation: 0,
      barrierColor: Colors.black.withValues(alpha: 0.68),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider(
          create: (context) => PinnedMessageBottomSheetCubit(
            groupId,
            getIt<FetchPinnedMessageInGroupUseCase>(),
            getIt<UnpinMessageUseCase>(),
          ),
          child: Stack(
            children: [
              // Tap to close bottom sheet
              Positioned.fill(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(color: Colors.transparent),
                ),
              ),
              PinnedMessagesBottomSheet(
                onTap: (messageId) {
                  Navigator.pop(context);
                  onTap(messageId);
                },
                onUnpinSuccess: () {
                  onUnpinSuccess();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  State<PinnedMessagesBottomSheet> createState() =>
      _PinnedMessagesBottomSheetState();
}

class _PinnedMessagesBottomSheetState extends State<PinnedMessagesBottomSheet> {
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _showOptionSheet(BuildContext context, String messageId) async {
    final cubit = context.read<PinnedMessageBottomSheetCubit>();
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
      cubit.unpinMessage(messageId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 1,
      expand: true,
      builder: (context, scrollController) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerGrayStrong0,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: MultiBlocListener(
            listeners: [
              BlocListener<
                PinnedMessageBottomSheetCubit,
                PinnedMessageBottomSheetState
              >(
                listenWhen: (previous, current) =>
                    previous.pagingStatus != current.pagingStatus,
                listener: (context, state) {
                  _refreshController.refresh(state.pagingStatus);
                },
              ),
              BlocListener<
                PinnedMessageBottomSheetCubit,
                PinnedMessageBottomSheetState
              >(
                listenWhen: (previous, current) =>
                    previous.isUnpinSuccess != current.isUnpinSuccess,
                listener: (context, state) {
                  if (state.isUnpinSuccess) {
                    widget.onUnpinSuccess?.call();
                    context
                        .read<PinnedMessageBottomSheetCubit>()
                        .resetUnpinSuccess();
                  }
                },
              ),
              BlocListener<
                PinnedMessageBottomSheetCubit,
                PinnedMessageBottomSheetState
              >(
                listenWhen: (previous, current) =>
                    previous.pinnedMessages != current.pinnedMessages,
                listener: (context, state) {
                  if (state.pinnedMessages.isEmpty) {
                    if (state.pagingStatus != PagingStatus.empty &&
                        state.pagingStatus != PagingStatus.noMoreData) {
                      context
                          .read<PinnedMessageBottomSheetCubit>()
                          .loadPinnedMessage();
                    } else if (state.pagingStatus == PagingStatus.noMoreData) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.pop();
                      });
                    }
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
                Expanded(
                  child:
                      BlocBuilder<
                        PinnedMessageBottomSheetCubit,
                        PinnedMessageBottomSheetState
                      >(
                        buildWhen: (previous, current) =>
                            previous.pageStatus != current.pageStatus ||
                            previous.pinnedMessages != current.pinnedMessages,
                        builder: (context, state) {
                          if (state.pageStatus == PageStatus.loading) {
                            return const Center(
                              child: CupertinoActivityIndicator(),
                            );
                          }

                          if (state.pinnedMessages.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return AppPullToRefresh(
                            scrollController: scrollController,
                            refreshController: _refreshController,
                            onRefresh: () {
                              context
                                  .read<PinnedMessageBottomSheetCubit>()
                                  .refreshPinnedMessages();
                            },
                            onLoadMore: () {
                              context
                                  .read<PinnedMessageBottomSheetCubit>()
                                  .loadMorePinnedMessages();
                            },
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
                                    widget.onTap?.call(messageId);
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
              ],
            ),
          ),
        );
      },
    );
  }
}
