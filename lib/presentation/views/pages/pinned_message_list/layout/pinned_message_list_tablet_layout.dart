import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';
import '../../../widgets/app_list_view.dart';
import '../../../widgets/pinned_message_bubble.dart';
import '../bloc/pinned_message_list_bloc.dart';
import '../widgets/pinned_message_empty_view.dart';
import '../widgets/pinned_message_loading_item.dart';

class PinnedMessageListTabletLayout extends StatefulWidget {
  const PinnedMessageListTabletLayout({super.key});

  @override
  State<PinnedMessageListTabletLayout> createState() =>
      _PinnedMessageListTabletLayoutState();
}

class _PinnedMessageListTabletLayoutState
    extends State<PinnedMessageListTabletLayout> {
  late final PinnedMessageListBloc _pinnedMessageListBloc;

  @override
  void initState() {
    super.initState();
    _pinnedMessageListBloc = context.read<PinnedMessageListBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackgroundBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBackgroundBackground,
        centerTitle: true,
        title: Text(
          'pinned_message_list.title'.tr(),
          style: TextStyle(
            fontFamily: FontFamily.segoeUI,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            height: 28 / 22,
            color: AppColors.textDefaultTextDefault,
          ),
        ),
        leadingWidth: 52,
        leading: Container(
          padding: const EdgeInsets.only(left: 12),
          alignment: Alignment.centerLeft,
          child: IconButton(
            padding: EdgeInsets.all(8),
            onPressed: () {
              context.router.pop();
            },
            icon: Assets.icons.icArrowLeft.svg(
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                AppColors.iconDefaultDefaultSub2,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        scrolledUnderElevation: 0,
      ),
      body: BlocBuilder<PinnedMessageListBloc, PinnedMessageListState>(
        buildWhen: (prev, curr) =>
            prev.pagingStatus != curr.pagingStatus ||
            prev.pinnedMessages != curr.pinnedMessages ||
            prev.isLoadedData != curr.isLoadedData,
        builder: (_, state) {
          if (state.isLoadedData && state.pinnedMessages.isEmpty) {
            return PinnedMessageEmptyView();
          } else {
            return AppListView(
              enablePullDown: false,
              onLoadMore: () {
                _pinnedMessageListBloc.add(LoadMorePinMessageInGroupEvent());
              },
              cardLoading: PinnedMessageLoadingItem(),
              numCardLoading: 6,
              fetchStatus: state.pagingStatus,
              data: state.pinnedMessages,
              builder: (_, index) {
                final message = state.pinnedMessages[index];

                return PinnedMessageBubble(
                  key: ValueKey(message.id),
                  message: message,
                  hasArrow: true,
                  onTap: () {
                    context.router.pop(message.id);
                  },
                  unpin: () {
                    final messageId = message.id;
                    if (messageId == null) return;
                    _pinnedMessageListBloc.add(
                      UnpinMessageInGroupEvent(messageId: messageId),
                    );
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
            );
          }
        },
      ),
    );
  }
}
